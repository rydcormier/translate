/**
* Transate: React Native app
*
* @format
* @flow strict-local
*/

import React from 'react';
import {
    SafeAreaView,
    StyleSheet,
    ScrollView,
    View,
    Text,
    StatusBar,
    Button
} from 'react-native';

import {
    Header,
    Colors,
    LanguagePicker,
    SourceText,
    TargetText,
    Controller,
    styles
} from './src/components';

const App: () => React$Node = () => {
    return (
        <>
        <StatusBar barStyle="dark-content" />
        <SafeAreaView>
            <ScrollView
                contentInsetAdjustmentBehavior="automatic"
                style={styles.scrollView}>
                <Header />
                
                {/* body */}
                <View style={styles.body}>

                    {/* controller */}
                    <View style={styles.container}>
                        <Controller />
                    </View>
                    {/* END controller */}

                </View>
                {/* END body*/}

            </ScrollView>
        </SafeAreaView>
        </>
);
};

export default App;
