import React, { useState } from 'react';
import {
    View,
    Text,
    TextInput,
    Button,
    StyleSheet
} from 'react-native';

import { Colors, LanguagePicker } from '../components';

const Controller = (props) => {
    return (
        <>
        <LanguagePicker />
        <Button title="Translate" />
        </>
    );
}

export default Controller;
