import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';

import { makeStyles } from '@material-ui/core/styles';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Paper from '@material-ui/core/Paper';
import Link from '@material-ui/core/Link';

import EditTagsDialog from './EditTagsDialog';

import { ApplicationState } from '../store';
import { RepositoryState, Repository } from '../store/repository/types';

const useStyles = makeStyles({
    table: {
        minWidth: 650,
    },
});

const RepositoryList: React.FC = () => {
    const classes = useStyles();
    const [open, setOpen] = useState(false);
    const [repository, setRepository] = useState<Repository>({
        id: 0,
        github_repository_id: 0,
        name: "",
        description: "",
        url: "",
        language: null,
        tags: []
    })
    const repositories = useSelector<ApplicationState, RepositoryState>((state: ApplicationState) => state.repository);

    useEffect(() => {
        // console.log(repositories.data)
    }, [repositories])

    const handleClickOpen = (repository: any) => {
        setOpen(true);
        setRepository(repository);
    };

    const handleClose = () => {
        setOpen(false);
    };

    return (
        <>
            <TableContainer component={Paper}>
                <Table className={classes.table} aria-label="simple table">
                    <TableHead>
                        <TableRow>
                            <TableCell>Repository</TableCell>
                            <TableCell>Description</TableCell>
                            <TableCell>Language</TableCell>
                            <TableCell>Tags</TableCell>
                            <TableCell>&nbsp;</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {repositories.data.map((repository: Repository) => (
                            <TableRow key={repository.github_repository_id}>
                                <TableCell component="th" scope="row">
                                    <Link href={repository.url}>
                                        {repository.name}
                                    </Link>
                                </TableCell>
                                <TableCell>{repository.description}</TableCell>
                                <TableCell>{repository.language}</TableCell>
                                <TableCell>{repository.tags.map((tag: any) => `#${tag.name} `)}</TableCell>
                                <TableCell>
                                    <Link onClick={() => { handleClickOpen(repository) }}>
                                        edit
                                    </Link>
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </TableContainer>
            <EditTagsDialog repository={repository} open={open} handleClose={handleClose} />
        </>
    );
}

export default RepositoryList;