import 'package:flutter/material.dart';
import 'package:repositories_management/blocs/home_bloc.dart';

class HomePage extends StatelessWidget {
  final homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories'),
      ),
      body: RefreshIndicator(
        onRefresh: homeBloc.updateUsers,
        child: Center(
          child: StreamBuilder(
            stream: homeBloc.users,
            initialData: UserLoadingState(),
            builder: (BuildContext _, AsyncSnapshot<UserState> snapshot) {
              final state = snapshot.data;
              if (state is UserLoadingState) return _loadingBuild();
              if (state is UserListState) return _userListBuild(state);
              if (state is UserEmptyState) return _emptyBuild();
              if (state is UserErrorState) return _errorBuild(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _userListBuild(UserListState state) {
    final listTile = state.list.map((user) {
      return ListTile(title: Text(user.name), subtitle: Text(user.email));
    }).toList();

    return ListView(
      scrollDirection: Axis.vertical,
      children: listTile,
    );
  }

  Widget _loadingBuild() {
    return CircularProgressIndicator();
  }

  Widget _emptyBuild() {
    return Text('Nenhum usuário listado');
  }

  Widget _errorBuild(UserErrorState state) {
    return Text(state.message);
  }
}
