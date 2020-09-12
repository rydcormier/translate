import React from 'react';

import { StyleSheet } from 'react-native';

import { Colors } from '../Components';

const styles = StyleSheet.create({
  scrollView: {
    backgroundColor: Colors.white,
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
    fontSize: 20,
    fontWeight: '600',
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
  rowContainer : {
      flex: 1,
      flexDirection: 'row',
      justifyContent: 'space-between',
  },
  bottomBorder : {
      borderBottomColor: Colors.light,
      borderBottomWidth: 1,
  },
  mainButton : {
      fontSize: 18,
      fontWeight: '600',
      backgroundColor: Colors.purple,
  },
  bordered : {
      borderColor: Colors.purple,
      borderWidth: 1,
      height: 100,
      padding: 12
  },
});

export default styles;
