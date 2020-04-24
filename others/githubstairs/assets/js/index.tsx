const _css = require("../css/app.css");

import "phoenix_html";

import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import { createBrowserHistory } from "history";
import configureStore from "./configureStore";

const history = createBrowserHistory();

const initialState: any = {};
const store = configureStore(history, initialState);

ReactDOM.render(<App store={store} history={history} />, document.getElementById('react-app'));