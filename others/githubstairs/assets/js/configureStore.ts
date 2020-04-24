import { Store, createStore, applyMiddleware, compose } from "redux";
import createSagaMiddleware from "redux-saga";
import thunk from "redux-thunk";
import { routerMiddleware } from "connected-react-router";
import { History } from "history";
import { ApplicationState, createRootReducer } from "./store";
export default function configureStore(
  history: History,
  initialState: ApplicationState
): Store<ApplicationState> {
  const sagaMiddleware = createSagaMiddleware();

  const composeEnhancer =
    (process.env.NODE_ENV !== 'production' &&
      (window as any)['__REDUX_DEVTOOLS_EXTENSION_COMPOSE__']) ||
    compose;

  const store = createStore(
    createRootReducer(history),
    initialState,
    composeEnhancer(applyMiddleware(routerMiddleware(history), thunk, sagaMiddleware))
  );

  // sagaMiddleware.run(rootSaga);
  return store;
}