/**
* Transate: React Native app
*
* @format
* @flow strict-local
*/

import React, { useState, useEffect } from 'react';
import {
    SafeAreaView,
    StyleSheet,
    ScrollView,
    View,
    Text,
    StatusBar,
    Button
} from 'react-native';

import { Picker } from '@react-native-community/picker';

import {
    Header,
    Colors,
    Controller,
    AppController,
    styles
} from './src/Components';

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
                        <AppController />
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
