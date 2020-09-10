import React, { useEffect, useState } from 'react';
import {
    View,
    Text,
    TextInput,
    Button,
    StyleSheet,
    ActivityIndicator,
    FlatList
} from 'react-native';

import { Colors } from './Colors';



const TargetText = (props) => {
    const [ text, setText ] = useState('Bonjour le monde!');
    const [isLoading, setLoading] = useState(true);
    const [ data, setData ] = useState([]);

    useEffect(() => {
        const data = { 'sl' : props.sl, 'tl' : props.tl, 'q' : props.q, };
        var formBody = [];
        for (var property in data) {
            var encodedKey = encodeURIComponent(property);
            var encodedValue = encodeURIComponent(data[property]);
            formBody.push(encodedKey + "=" + encodedValue);
        }

        formBody = formBody.join("&");
        fetch('https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e&',
        { method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'User-Agent': 'AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1',
            },
            body: formBody }
        )
        .then((response) => response.json())
      .then((json) => setData(json.sentences))
      .catch((error) => console.error(error))
      .finally(() => setLoading(false));
  }, []);

    return (
        <View style={{ flex: 1, padding: 24 }}>
            { isLoading ? <ActivityIndicator /> : (
                <FlatList
                    data={ data }
                    keyExtractor={ ({ id }, index) => id }
                    renderItem={ ({ item }) => (
                        <Text>{ item.trans }</Text>
                    )}
                    />
            )}
        </View>
    );
};

export default TargetText;
