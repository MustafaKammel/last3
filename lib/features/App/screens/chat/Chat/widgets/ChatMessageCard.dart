import 'dart:async';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../firebase/fire_database.dart';
import '../../models/message_model.dart';
import '../../utill/colors.dart';
import '../../utill/photo_view.dart';

class ChatMessageCard extends StatefulWidget {
  const ChatMessageCard(
      {super.key, required this.index, required this.messageItem, required this.rromId, required this.selected});

  final int index;
  final String rromId;
  final Message messageItem;
  final bool selected;

  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
  VideoPlayerController? _controller;
  Future<void>? _initializedVideoplayer;
  // PDFDocument? _pdfDocument; // Initialize as nullable

  PDFDocument? Document;


void initializepdf()async
{
  Document = await PDFDocument.fromURL(widget.messageItem.msg!);
  setState(() {});
}


  final bool _isLoading = true;

  @override
  void initState() {
    if (widget.messageItem.toId == FirebaseAuth.instance.currentUser!.uid) {
      FireData().readMessage(widget.rromId, widget.messageItem.id!);
    }

    _controller = VideoPlayerController.network(widget.messageItem.msg!);
    _initializedVideoplayer = _controller!.initialize();
    _controller!.setLooping(true);

    // _loadPDF(); // Call _loadPDF in initState
    super.initState();
  }

  // Future<void> _loadPDF() async {
  //   try {
  //     Reference ref = FirebaseStorage.instance.ref('${widget.messageItem.msg!}');
  //     String downloadURL = await ref.getDownloadURL();
  //     print('Download URL: $downloadURL'); // Print download URL for debugging
  //     _pdfDocument = await PDFDocument.fromURL(downloadURL);
  //     if (_pdfDocument != null) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     } else {
  //       print('PDF document is null'); // Print error message for debugging
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error loading PDF: $e'); // Print error message for debugging
  //     setState(() {
  //       _isLoading = false;});
  //   }
  // }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.messageItem.fromId == FirebaseAuth.instance.currentUser!.uid;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.selected ? Colors.lightBlue : Colors.transparent,
      ),
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isMe ? IconButton(onPressed: () {}, icon: const Icon(Iconsax.message_edit)) : const SizedBox(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(isMe ? 10 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 10),
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              ),
            ),
            color: isMe ? Colors.grey : kprimary.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.messageItem.type == 'image'
                        ? GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => photoView(image: widget.messageItem.msg!),
                        ),
                      ),
                      child: Container(
                        child: CachedNetworkImage(
                          fit: BoxFit.contain,
                          imageUrl: widget.messageItem.msg!,
                        ),
                      ),
                    )
                        : widget.messageItem.type == 'text'
                        ? Text(
                      widget.messageItem.msg!,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                        : widget.messageItem.type == 'video'
                        ? Container(child:Document !=null? PDFViewer(document: Document!)
                        :const CircularProgressIndicator() ,)
                        : Container(
                      child: FutureBuilder(
                        future: _initializedVideoplayer,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                    } else {
                                      _controller!.play();
                                    }
                                  });
                                },
                                child: VideoPlayer(_controller!),
                              ),
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isMe ? Icon(Iconsax.tick_circle, color: widget.messageItem.read == "" ? Colors.grey : Colors.blueAccent) : const SizedBox(),
                        const SizedBox(width: 10),
                        Text(
                            DateFormat.Hms().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.messageItem.createdAt!))).toString()),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.yMMMEd()
                              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.messageItem.createdAt!)))
                              .toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}