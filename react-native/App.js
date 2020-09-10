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
    Controller
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

            {/* source */}
            <View style={[
                    styles.container, {borderBottomColor: Colors.light,
                        borderBottomWidth: 1,}]}>
                <SourceText />
            </View>
            {/* END source */}

            {/* controller */}
            <View style={styles.container}>
                <Controller />
            </View>
            {/* END controller */}

            {/* target */}
            <View style={styles.sectionContainer}>
              <TargetText
                  sl="en"
                  tl="fr"
                  q="Hello world!"
                  />
            </View>
            {/* END target */}

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
