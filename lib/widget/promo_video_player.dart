import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../helper_files/app_colors.dart';

class PromoVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isAutoPlay;

  const PromoVideoPlayer({
    super.key,
    required this.videoUrl,
    this.isAutoPlay = false,
  });

  @override
  State<PromoVideoPlayer> createState() => _PromoVideoPlayerState();
}

class _PromoVideoPlayerState extends State<PromoVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubeController;

  bool _isYoutube = false;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _checkVideoTypeAndInitialize();
  }

  void _checkVideoTypeAndInitialize() async {
    if (widget.videoUrl.isEmpty) {
      if (mounted) setState(() => _isError = true);
      return;
    }

    if (widget.videoUrl.toLowerCase().contains("youtube.com") ||
        widget.videoUrl.toLowerCase().contains("youtu.be")) {
      _isYoutube = true;
      _initializeYoutubePlayer();
    } else {
      _isYoutube = false;
      await _initializeNormalPlayer();
    }
  }

  void _initializeYoutubePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: widget.isAutoPlay,
          mute: false,
          enableCaption: false,
          isLive: false,
          forceHD: false,
        ),
      );
      if (mounted) setState(() => _isLoading = false);
    } else {
      if (mounted) setState(() => _isError = true);
    }
  }

  Future<void> _initializeNormalPlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: widget.isAutoPlay,
        looping: false,
        aspectRatio: 14 / 7,
        errorBuilder: (context, errorMessage) {
          return const Center(child: Text("Video Error", style: TextStyle(color: Colors.white)));
        },
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.appbarColor,
          handleColor: AppColors.appbarColor,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() => _isError = true);
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const Text("Video Unavailable", style: TextStyle(color: Colors.white)),
      );
    }

    if (_isLoading) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: AppColors.appbarColor),
      );
    }

    if (_isYoutube && _youtubeController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.appbarColor,
        progressColors: ProgressBarColors(
          playedColor: AppColors.appbarColor,
          handleColor: AppColors.appbarColor,
        ),
      ));
    }

    if (!_isYoutube && _chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const SizedBox.shrink();
  }
}



