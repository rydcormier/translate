/**
 * Sample React Native App
 * https://github.com/facebook/react-native
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
  LearnMoreLinks,
  DebugInstructions,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

import { Header, Colors, LanguagePicker } from './src/components';

const App: () => React$Node = () => {
  return (
    <>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView>
        <ScrollView
          contentInsetAdjustmentBehavior="automatic"
          style={styles.scrollView}>
          <Header />
          {global.HermesInternal == null ? null : (
            <View style={styles.engine}>
              <Text style={styles.footer}>Engine: Hermes</Text>
            </View>
          )}

          {/* body */}
          <View style={styles.body}>

            {/* source */}
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Enter Some Text</Text>
              <Text style={styles.sectionDescription}>
                Hello world!
              </Text>
            </View>
            {/* END source */}

            {/* picker */}
            <View style={styles.sectionContainer}>
                <LanguagePicker />
            </View>
            {/* END picker */}

            {/* controller */}
            <View style={[styles.sectionContainer, styles.button]}>
                <Button color={Colors.white} title="Translate" />
            </View>
            {/* END controller */}

            {/* target */}
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>See Your Translation</Text>
              <Text style={styles.sectionDescription}>
                Bonjour le monde!
              </Text>
            </View>
            {/* END target */}

            {/*}
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Debug</Text>
              <Text style={styles.sectionDescription}>
                <DebugInstructions />
              </Text>
            </View>
            */}
            {/*
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Learn More</Text>
              <Text style={styles.sectionDescription}>
                Read the docs to discover what to do next:
              </Text>
            </View>
            <LearnMoreLinks />
            */}
        </View>
        {/* END body*/}

        </ScrollView>
      </SafeAreaView>
    </>
  );
};

const styles = StyleSheet.create({
  scrollView: {
    backgroundColor: Colors.lighter,
  },
  engine: {
    position: 'absolute',
    right: 0,
  },
  body: {
    backgroundColor: Colors.white,
  },
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: Colors.black,
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
    color: Colors.dark,
  },
  highlight: {
    fontWeight: '700',
  },
  footer: {
    color: Colors.dark,
    fontSize: 12,
    fontWeight: '600',
    padding: 4,
    paddingRight: 12,
    textAlign: 'right',
  },
  button: {
      backgroundColor: Colors.purple,
      justifyContent: 'center',
      alignItems: 'center',
      marginHorizontal: 24,
  },
});

export default App;
