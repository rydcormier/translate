import React, { useState } from 'react';
import {
    View,
    Text,
    TextInput,
    Button,
    StyleSheet
} from 'react-native';

import Colors from './Colors';

const SourceText = (props) => {
    const [ text, setText ] = useState('Hello world!');
    return (
        <>
        <View
            style={{
                flex:1,
                flexDirection:'row',
                justifyContent:'space-between',
                borderBottomColor:Colors.light,
                borderBottomWidth:1 }}
                >
                <Text style={styles.title}>Enter some text</Text>
                <Button
                    style={styles.button}
                    title="Clear"
                    onPress={() => setText('')}
                    />
            </View>
            <TextInput
                style={styles.input}
                onChangeText={text => setText(text)}
                defaultValue={text}

                onSubmitEditing={() => setText("Submit Editing")}
                />
            </>
    );
}

styles = StyleSheet.create({
    title: {
        fontSize: 24,
        fontWeight: '600',
    },
    button: {},
    input: {
        height: 80,
    },
});

export default SourceText;
