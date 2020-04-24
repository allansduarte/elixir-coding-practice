import * as React from "react";
import { Provider } from 'react-redux';
import { Store } from "redux";
import { History } from "history";
import { ConnectedRouter } from "connected-react-router";

import Routes from './routes';
import Header from './components/Header';

import { ApplicationState } from './store';

interface MainProps {
  store: Store<ApplicationState>;
  history: History;
}

const App: React.FC<MainProps> = ({ store, history }) => {
  return (
    <Provider store={store}>
      <ConnectedRouter history={history}>
        <main className="wrapper">
          <Header />
          <Routes />
        </main>
      </ConnectedRouter>
    </Provider>
  )
}

export default App;