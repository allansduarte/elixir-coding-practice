import * as React from 'react';
import { Link as RouterLink } from 'react-router-dom';

import { makeStyles, Theme } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Button from '@material-ui/core/Button';
import Link from '@material-ui/core/Link';

const useStyles = makeStyles((theme: Theme) => ({
  title: {
    flexGrow: 1,
  },
}));

const Header: React.FC = () => {
  const classes = useStyles();

  return (
    <AppBar position="static">
      <Toolbar>
        <Typography variant="h6" className={classes.title}>
          <Link
            to="/"
            component={RouterLink}
            color="inherit"
          >
            Githubstars
          </Link>
        </Typography>
        <Button component={RouterLink} variant="outlined" color="inherit" to="/">Home</Button>
      </Toolbar>
    </AppBar>
  );
};

export default Header;
