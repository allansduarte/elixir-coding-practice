import React from 'react';

import { makeStyles, Theme } from '@material-ui/core/styles';
import InputBase from '@material-ui/core/InputBase';;
import { fade } from '@material-ui/core/styles';
import Container from '@material-ui/core/Container';

import SearchIcon from '@material-ui/icons/Search';

interface Props {
    changed: any;
    value: string;
}

const useStyles = makeStyles((theme: Theme) => ({
    container: {
        display: "flex",
        flexDirection: "row",
        margin: theme.spacing(1, 0),
        justifyContent: "space-between",
        alignItems: "center"
    },
    search: {
        position: 'relative',
        borderRadius: theme.shape.borderRadius,
        backgroundColor: fade(theme.palette.secondary.main, 0.15),
        '&:hover': {
            backgroundColor: fade(theme.palette.secondary.main, 0.25),
        },
        width: '100%',
        maxHeight: '3rem',
    },
    searchIcon: {
        width: theme.spacing(7),
        height: '100%',
        position: 'absolute',
        pointerEvents: 'none',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
    },
    inputRoot: {
        color: 'inherit',
        height: '3rem',
        width: "100%",
    },
    inputBase: {
        padding: theme.spacing(1, 1, 1, 7),
    }
}))

const SearchField: React.FC<Props> = (props: Props) => {
    const classes = useStyles()

    return (
        <Container className={classes.container} maxWidth="xl">
            <div className={classes.search}>
                <div className={classes.searchIcon}>
                    <SearchIcon color="secondary" />
                </div>
                <InputBase
                    placeholder="Search by tag"
                    classes={{
                        root: classes.inputRoot,
                        input: classes.inputBase,
                    }}
                    value={props.value}
                    onChange={props.changed}
                    inputProps={{ 'aria-label': 'search', 'name': 'search', 'autoComplete': "off" }}
                />
            </div>
        </Container>
    )
}

export default SearchField;