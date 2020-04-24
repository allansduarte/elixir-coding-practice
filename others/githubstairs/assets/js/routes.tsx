import React from "react";
import { Route, Switch } from 'react-router-dom';

import HomePage from "./pages/HomePage";
import RepositoriesListPage from "./pages/Repositories";
import NoMatchPage from "./pages/NoMatch";

const Routes: React.SFC = () => (
    <Switch>
        <Route exact path="/" component={HomePage} />
        <Route exact path="/repositories" component={RepositoriesListPage} />
        <Route component={NoMatchPage} />
    </Switch>
);

export default Routes;