import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCall extends StatefulWidget {
  final String channelName;
  const VideoCall({Key? key, required this.channelName}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late RtcEngine _engine;

  final String appId = "";
  final String token = "";
  int? _remoteUid;
  bool _localJoined = false;

  bool _micMuted = false;
  bool _cameraOff = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.enableVideo();
    await _engine.startPreview();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() => _localJoined = true);
        },
        onUserJoined: (connection, uid, elapsed) {
          setState(() => _remoteUid = uid);
        },
        onUserOffline: (connection, uid, reason) {
          setState(() => _remoteUid = null);
        },
      ),
    );

    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  // ---------------- VIDEO VIEWS ----------------

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    }
    return const Center(
      child: Text(
        "waiting for another members",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _localVideo() {
    if (!_localJoined || _cameraOff) return const SizedBox();
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// FULL SCREEN REMOTE
          Positioned.fill(child: _remoteVideo()),

          /// FLOATING LOCAL PREVIEW
          Positioned(
            top: 50,
            right: 20,
            width: 120,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _localVideo(),
              ),
            ),
          ),

          /// BOTTOM CONTROLS (WhatsApp style)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _controlButton(
                  icon: _micMuted ? Icons.mic_off : Icons.mic,
                  onTap: () async {
                    _micMuted = !_micMuted;
                    await _engine.muteLocalAudioStream(_micMuted);
                    setState(() {});
                  },
                ),
                _endCallButton(),
                _controlButton(
                  icon: _cameraOff ? Icons.videocam_off : Icons.videocam,
                  onTap: () async {
                    _cameraOff = !_cameraOff;
                    await _engine.muteLocalVideoStream(_cameraOff);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.black.withOpacity(0.6),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }

  Widget _endCallButton() {
    return CircleAvatar(
      radius: 32,
      backgroundColor: Colors.red,
      child: IconButton(
        icon: const Icon(Icons.call_end, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
