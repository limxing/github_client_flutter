import 'package:flutter/material.dart';
import 'package:github_client_flutter/common/my_icons.dart';
import 'package:github_client_flutter/models/repo.dart';

class RepoItem extends StatefulWidget {
  RepoItem(this.repo) : super(key: ValueKey(repo.id));

  final Repo repo;

  @override
  _RepoItemState createState() => _RepoItemState();
}

class _RepoItemState extends State<RepoItem> {
  @override
  Widget build(BuildContext context) {
    var subtitle;
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.white,
        shape: BorderDirectional(
          bottom: BorderSide(
            color: Colors.black.withAlpha(100),
            width: .5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 0.0, bottom: 16),
          child: Column(
            children: [
              ListTile(
                dense: true,
                leading: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircleAvatar(
                    child: Image.network(widget.repo.owner.avatar_url ?? ""),
                  ),
                ),
                title: Text(
                  widget.repo.owner.login ?? "",
                  textScaleFactor: .9,
                ),
                subtitle: subtitle,
                trailing: Text(widget.repo.language ?? ""),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.repo.fork
                          ? widget.repo.full_name
                          : widget.repo.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: widget.repo.fork
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 12,
                      ),
                      child: widget.repo.description == null
                          ? Text(
                              "没有简介",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700]),
                            )
                          : Text(
                              widget.repo.description,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                                color: Colors.blueGrey[700],
                                height: 1.15,
                              ),
                              maxLines: 3,
                            ),
                    )
                  ],
                ),
              ),
              _buildBottom()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    const paddingWidth = 10;
    return IconTheme(
      data: const IconThemeData(
        color: Colors.grey,
        size: 15,
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Builder(builder: (context) {
            var children = [
              const Icon(Icons.star),
              Text(" " +
                  widget.repo.stargazers_count
                      .toString()
                      .padRight(paddingWidth)),
              const Icon(Icons.info_outline),
              Text(" " +
                  widget.repo.open_issues_count
                      .toString()
                      .padRight(paddingWidth)),
              const Icon(BeeIcons.gift),
              Text(
                widget.repo.forks_count.toString().padRight(
                      paddingWidth,
                    ),
              ),
            ];
            if (widget.repo.fork) {
              children.add(
                Text(
                  "forked".padRight(
                    paddingWidth,
                  ),
                ),
              );
            }
            if (widget.repo.private == true) {
              children.addAll([
                const Icon(Icons.lock),
                Text(
                  " private".padRight(
                    paddingWidth,
                  ),
                ),
              ]);
            }
            return Row(
              children: children,
            );
          }),
        ),
      ),
    );
  }
}
