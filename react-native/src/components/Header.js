/**
 * Copyright (c) Ryan Cormier <rydcormier@gmail.com>
 *
 * This source code is licensed under the MIT license.
 *
 * @flow strict-local
 * @format
 */

'use strict';
import Colors from './Colors';
import type {Node} from 'react';
import {Text, StyleSheet, ImageBackground} from 'react-native';
import React from 'react';

const Header = (): Node => (
  <ImageBackground
    accessibilityRole={'image'}
    source={require('./logo.png')}
    style={styles.background}
    imageStyle={styles.logo}>
    <Text style={styles.text}>Translate</Text>
  </ImageBackground>
);

const styles = StyleSheet.create({
  background: {
    paddingBottom: 40,
    paddingTop: 96,
    paddingHorizontal: 32,
    backgroundColor: Colors.white,
  },
  logo: {
    opacity: 0.2,
    overflow: 'visible',
    resizeMode: 'cover',
    marginLeft: -128,
    marginBottom: -192,
  },
  text: {
    fontSize: 40,
    fontWeight: '600',
    textAlign: 'center',
    color: Colors.purple,
  },
});

export default Header;
