import React, { useState, useEffect } from 'react';
import {
    View,
    Text,
    TextInput,
    Button,
} from 'react-native';

import { Picker } from '@react-native-community/picker';

import { Colors, PickerItems, styles } from '../components';

const Controller = (props) => {
    const [sourceText, setSourceText ] = useState('Hello world!');
    const [ targetLanguage, setTargetLanguage ] = useState('fr');
    const [ targetText, setTargetText ] = useState('Bonjour le monde!');
    const [ data, setData ] = useState([]);
    const [ isLoading, setIsLoading ] = useState(true);

    return (
        <>
        {/* source */}
        <View style={styles.sectionContainer}>
            <View style={styles.rowContainer}>
                <Text style={styles.sectionTitle}>Enter some text</Text>
                <Button title="Clear" onPress={() => setSourceText('')} />
            </View>
            <View style={styles.bordered}>
                <TextInput
                    style={styles.sectionDescription}
                    defaultValue={ sourceText }
                    onChangeText={ text => setSourceText(text) }
                    />
            </View>
        </View>
        {/* END source */}

        {/* picker */}
        <View style={styles.sectionContainer}>
            <Text style={styles.sectionTitle}>Choose a language</Text>
            <Picker
                selectedValue={ targetLanguage }
                onValueChange={ (itemValue, itemIndex ) => setTargetLanguage(itemValue) }>
                <Picker.Item label="afrikaans" value="af" />
                <Picker.Item label="albanian" value="sq" />
                <Picker.Item label="amharic" value="am" />
                <Picker.Item label="arabic" value="ar" />
                <Picker.Item label="armenian" value="hy" />
                <Picker.Item label="azerbaijani" value="az" />
                <Picker.Item label="basque" value="eu" />
                <Picker.Item label="belarusian" value="be" />
                <Picker.Item label="bengali" value="bn" />
                <Picker.Item label="bosnian" value="bs" />
                <Picker.Item label="bulgarian" value="bg" />
                <Picker.Item label="catalan" value="ca" />
                <Picker.Item label="cebuano" value="ceb" />
                <Picker.Item label="chichewa" value="ny" />
                <Picker.Item label="chinese (simplified)" value="zh-cn" />
                <Picker.Item label="chinese (traditional)" value="zh-tw" />
                <Picker.Item label="corsican" value="co" />
                <Picker.Item label="croatian" value="hr" />
                <Picker.Item label="czech" value="cs" />
                <Picker.Item label="danish" value="da" />
                <Picker.Item label="dutch" value="nl" />
                <Picker.Item label="english" value="en" />
                <Picker.Item label="esperanto" value="eo" />
                <Picker.Item label="estonian" value="et" />
                <Picker.Item label="filipino" value="tl" />
                <Picker.Item label="finnish" value="fi" />
                <Picker.Item label="french" value="fr" />
                <Picker.Item label="frisian" value="fy" />
                <Picker.Item label="galician" value="gl" />
                <Picker.Item label="georgian" value="ka" />
                <Picker.Item label="german" value="de" />
                <Picker.Item label="greek" value="el" />
                <Picker.Item label="gujarati" value="gu" />
                <Picker.Item label="haitian creole" value="ht" />
                <Picker.Item label="hausa" value="ha" />
                <Picker.Item label="hawaiian" value="haw" />
                <Picker.Item label="hebrew" value="iw" />
                <Picker.Item label="hebrew" value="he" />
                <Picker.Item label="hindi" value="hi" />
                <Picker.Item label="hmong" value="hmn" />
                <Picker.Item label="hungarian" value="hu" />
                <Picker.Item label="icelandic" value="is" />
                <Picker.Item label="igbo" value="ig" />
                <Picker.Item label="indonesian" value="id" />
                <Picker.Item label="irish" value="ga" />
                <Picker.Item label="italian" value="it" />
                <Picker.Item label="japanese" value="ja" />
                <Picker.Item label="javanese" value="jw" />
                <Picker.Item label="kannada" value="kn" />
                <Picker.Item label="kazakh" value="kk" />
                <Picker.Item label="khmer" value="km" />
                <Picker.Item label="korean" value="ko" />
                <Picker.Item label="kurdish (kurmanji)" value="ku" />
                <Picker.Item label="kyrgyz" value="ky" />
                <Picker.Item label="lao" value="lo" />
                <Picker.Item label="latin" value="la" />
                <Picker.Item label="latvian" value="lv" />
                <Picker.Item label="lithuanian" value="lt" />
                <Picker.Item label="luxembourgish" value="lb" />
                <Picker.Item label="macedonian" value="mk" />
                <Picker.Item label="malagasy" value="mg" />
                <Picker.Item label="malay" value="ms" />
                <Picker.Item label="malayalam" value="ml" />
                <Picker.Item label="maltese" value="mt" />
                <Picker.Item label="maori" value="mi" />
                <Picker.Item label="marathi" value="mr" />
                <Picker.Item label="mongolian" value="mn" />
                <Picker.Item label="myanmar (burmese)" value="my" />
                <Picker.Item label="nepali" value="ne" />
                <Picker.Item label="norwegian" value="no" />
                <Picker.Item label="odia" value="or" />
                <Picker.Item label="pashto" value="ps" />
                <Picker.Item label="persian" value="fa" />
                <Picker.Item label="polish" value="pl" />
                <Picker.Item label="portuguese" value="pt" />
                <Picker.Item label="punjabi" value="pa" />
                <Picker.Item label="romanian" value="ro" />
                <Picker.Item label="russian" value="ru" />
                <Picker.Item label="samoan" value="sm" />
                <Picker.Item label="scots gaelic" value="gd" />
                <Picker.Item label="serbian" value="sr" />
                <Picker.Item label="sesotho" value="st" />
                <Picker.Item label="shona" value="sn" />
                <Picker.Item label="sindhi" value="sd" />
                <Picker.Item label="sinhala" value="si" />
                <Picker.Item label="slovak" value="sk" />
                <Picker.Item label="slovenian" value="sl" />
                <Picker.Item label="somali" value="so" />
                <Picker.Item label="spanish" value="es" />
                <Picker.Item label="sundanese" value="su" />
                <Picker.Item label="swahili" value="sw" />
                <Picker.Item label="swedish" value="sv" />
                <Picker.Item label="tajik" value="tg" />
                <Picker.Item label="tamil" value="ta" />
                <Picker.Item label="telugu" value="te" />
                <Picker.Item label="thai" value="th" />
                <Picker.Item label="turkish" value="tr" />
                <Picker.Item label="ukrainian" value="uk" />
                <Picker.Item label="urdu" value="ur" />
                <Picker.Item label="uyghur" value="ug" />
                <Picker.Item label="uzbek" value="uz" />
                <Picker.Item label="vietnamese" value="vi" />
                <Picker.Item label="welsh" value="cy" />
                <Picker.Item label="xhosa" value="xh" />
                <Picker.Item label="yiddish" value="yi" />
                <Picker.Item label="yoruba" value="yo" />
                <Picker.Item label="zulu" value="zu" />
            </Picker>
        </View>
        {/* END picker */}

        {/* target */}

        <View style={styles.sectionContainer}>
            <View style={{ backgroundColor: Colors.purple }}>
                <Button
                    title="Translate"
                    color={Colors.white}
                    />
            </View>
            <View style={[styles.bordered, {marginTop: 32, flex: 1, justifyContent: 'center'}]}>
                <Text
                    style={[styles.sectionDescription, {textAlign: 'center'}]}>
                    { targetText }
                </Text>
            </View>
        </View>
        {/* END target */}
        </>
);
}

export default Controller;
