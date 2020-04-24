import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from "react-redux";

import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';

import { manageTags } from "../store/repository/action";
import { ApplicationState } from '../store';
import { Repository, Tag, RepositoryState } from '../store/repository/types';

interface Props {
    open: any;
    handleClose: any;
    repository: Repository;
}

const EditTagsDialog: React.FC<Props> = (props: Props) => {
    const [tags, setTags] = useState("");
    const dispatch = useDispatch();
    const repositoryState = useSelector<ApplicationState, RepositoryState>((state: ApplicationState) => state.repository);

    useEffect(() => {
        setTags(props.repository?.tags.map((tag: Tag) => tag.name).join(", "));
    }, [props.repository]);

    useEffect(() => {
        if (repositoryState.data.length && !repositoryState.errors) {
            props.handleClose()
        }
    }, [repositoryState]);

    const handleChange = (event: any) => {
        setTags(event.target.value)
    }

    const handleTags = () => {
        dispatch(manageTags(props.repository.id, tags))
    }

    return (
        <Dialog open={props.open} onClose={props.handleClose} aria-labelledby="form-dialog-title">
            <DialogTitle id="form-dialog-title">Edit tags for <i>{props.repository?.name}</i></DialogTitle>
            <DialogContent>
                <TextField
                    autoFocus
                    margin="dense"
                    id="tags"
                    label="Tags"
                    type="text"
                    fullWidth
                    onChange={handleChange}
                    value={tags}
                />
            </DialogContent>
            <DialogActions>
                <Button onClick={handleTags} color="primary">
                    Save
                </Button>
                <Button onClick={props.handleClose} color="primary">
                    Cancel
                </Button>
            </DialogActions>
        </Dialog>
    )
}

export default EditTagsDialog;