class VoteModelService {
  int? _idUser;
  int? _vote;

  voteService({
    int? idUser,
    int? vote,
  }) {
    _idUser = idUser;
    _vote = vote;
  }

  int? get idUser => _idUser;
  int? get vote => _vote;

  VoteModelService.fromJson(Map<String, dynamic> json) {
    _idUser = json['idUser'];
    _vote = json['vote'];
  }
}
