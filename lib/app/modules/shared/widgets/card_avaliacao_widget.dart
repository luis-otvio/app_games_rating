import 'dart:async';

import 'package:app_games_rating/app/app_store.dart';
import 'package:app_games_rating/app/modules/feed/model/feed_details_model.dart';
import 'package:app_games_rating/app/modules/feed/page/feed_store.dart';
import 'package:app_games_rating/app/modules/shared/widgets/shadow_widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:like_button/like_button.dart';

class CardAvaliacaoWidget extends StatefulWidget {
  final FeedDetails feedDetails;
  final Function onBackFromClick;
  final bool exibirUsuario;
  final bool exibirLikes;

  CardAvaliacaoWidget(
    this.feedDetails,
    this.onBackFromClick, {
    this.exibirUsuario = true,
    this.exibirLikes = true,
  });

  @override
  _CardAvaliacaoWidgetState createState() => _CardAvaliacaoWidgetState();
}

class _CardAvaliacaoWidgetState extends State<CardAvaliacaoWidget> {
  final appController = Modular.get<AppStore>();
  final feedController = Modular.get<FeedStore>();
  final GlobalKey<LikeButtonState> _likeKey = GlobalKey<LikeButtonState>();
  final GlobalKey<LikeButtonState> _dislikeKey = GlobalKey<LikeButtonState>();

  bool _isLiked;
  bool _isDisliked;

  @override
  void initState() {
    _isLiked = widget.feedDetails.curtido;
    _isDisliked = widget.feedDetails.descurtido;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double alturaCard = 105;

    return InkWell(
      onTap: () => Modular.to.pushNamed('/feed/details', arguments: widget.feedDetails).then((value) {
        widget.onBackFromClick();
      }),
      child: Container(
        margin: EdgeInsets.only(top: 7, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[shadow()],
        ),
        child: Column(
          children: [
            Container(
              height: alturaCard,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                    ),
                    child: Image.network(
                      widget.feedDetails.feed.urlImage,
                      fit: BoxFit.cover,
                      width: 100,
                      height: alturaCard,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: alturaCard,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: widget.exibirUsuario ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                        children: [
                          widget.exibirUsuario
                              ? Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage("${widget.feedDetails.feed.urlImageUser}"),
                                      radius: 14,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      widget.feedDetails.feed.nickNameUser,
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : Container(),
                          Text(
                            widget.feedDetails.feed.evaluationUser,
                            maxLines: widget.exibirUsuario ? 3 : 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: widget.exibirLikes ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                    children: [
                      widget.exibirLikes
                          ? Row(
                              children: [
                                LikeButton(
                                  key: _likeKey,
                                  isLiked: _isLiked,
                                  circleColor: CircleColor(start: Color(0xFFFF879B), end: Color(0xFFFF5656)),
                                  bubblesColor: BubblesColor(dotPrimaryColor: Color(0xFFFF879B), dotSecondaryColor: Color(0xFFFF5656)),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                                      color: isLiked ? Colors.redAccent : Colors.grey,
                                    );
                                  },
                                  likeCount: widget.feedDetails.feed.like,
                                  countBuilder: (int count, bool isLiked, String text) {
                                    var color = isLiked ? Colors.redAccent : Colors.grey;
                                    Widget result = Text(text, style: TextStyle(color: color));
                                    return result;
                                  },
                                  onTap: (bool isLiked) async => onLikeButtonTapped(isLiked, widget.feedDetails.feed.idEvaluation),
                                ),
                                SizedBox(width: 10),
                                LikeButton(
                                  key: _dislikeKey,
                                  isLiked: _isDisliked,
                                  circleColor: CircleColor(start: Color(0xFFFF879B), end: Color(0xFFFF5656)),
                                  bubblesColor: BubblesColor(dotPrimaryColor: Color(0xFFFF879B), dotSecondaryColor: Color(0xFFFF5656)),
                                  likeBuilder: (bool isDisliked) {
                                    return Icon(
                                      isDisliked ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
                                      color: isDisliked ? Colors.redAccent : Colors.grey,
                                    );
                                  },
                                  likeCount: widget.feedDetails.feed.dislike,
                                  countBuilder: (int count, bool isDisliked, String text) {
                                    var color = isDisliked ? Colors.redAccent : Colors.grey;
                                    Widget result = Text(text, style: TextStyle(color: color));
                                    return result;
                                  },
                                  onTap: (bool isDisliked) async => onDislikeButtonTapped(isDisliked, widget.feedDetails.feed.idEvaluation),
                                ),
                              ],
                            )
                          : Container(),
                      Text(
                        "Postado em " + widget.feedDetails.feed.dateEvaluationCreate,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked, int idEvaluation) async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      text: "Carregando...",
      barrierDismissible: false,
    );

    // remove o dislike, caso esteja
    if (!isLiked && _isDisliked) {
      _dislikeKey.currentState.onTap();
    }

    _isLiked = !isLiked;

    await feedController.likeDislikeFeed(!isLiked ? 1 : 3, appController.usuarioLogado.id, idEvaluation, appController.usuarioLogado.accessToken).onError((error, stackTrace) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        barrierDismissible: false,
        title: "Ops!",
        text: error,
        onConfirmBtnTap: () {
          Modular.to.pushReplacementNamed('/');
        },
      );
    });

    Modular.to.pop();

    return !isLiked;
  }

  Future<bool> onDislikeButtonTapped(bool isDisliked, int idEvaluation) async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      text: "Carregando...",
      barrierDismissible: false,
    );

    // remove o dislike, caso esteja
    if (!isDisliked && _isLiked) {
      _likeKey.currentState.onTap();
    }

    _isDisliked = !isDisliked;

    await feedController
        .likeDislikeFeed(
      !isDisliked ? 2 : 3,
      appController.usuarioLogado.id,
      idEvaluation,
      appController.usuarioLogado.accessToken,
    )
        .onError((error, stackTrace) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        barrierDismissible: false,
        title: "Ops!",
        text: error,
        onConfirmBtnTap: () {
          Modular.to.pushReplacementNamed('/');
        },
      );
    });

    Modular.to.pop();

    return !isDisliked;
  }
}
