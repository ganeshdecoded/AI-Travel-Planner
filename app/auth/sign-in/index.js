import { View, Text, TextInput,StyleSheet } from 'react-native'
import React, { useEffect } from 'react'
import { useNavigation } from 'expo-router'
import { Colors } from './../../../constants/Colors';

export default function SignIn() {

    const navigation = useNavigation();

    useEffect(() => {
        navigation.setOptions({
            headerShown: false
        })
    }, [])

  return (
    <View style={{
        padding: 25,
        marginTop: 80,
        backgroundColor: Colors.WHITE,
        height: '100%',
    }}>
      <Text style={{ 
        textAlign: 'center',
        fontFamily: 'outfit-bold',
        fontSize: 30
        }}>Let's Sign you In</Text>

<Text style={{ 
        textAlign: 'center',
        fontFamily: 'outfit',
        fontSize: 30,
        marginTop: 20,
        color:Colors.GRAY
        }}>Welcome Back</Text>

<Text style={{ 
        textAlign: 'center',
        fontFamily: 'outfit',
        fontSize: 30,
        marginTop: 10,
        color:Colors.GRAY
        }}>You have been Missed!</Text>

        <View style={{ 
            marginTop: 50 
            }}>
            <Text style={{ fontFamily: 'outfit' }}>
                Email
            </Text>
            <TextInput
            style={styles.input}
            placeholder='Enter Email'></TextInput>
        </View>

        <View style={{ 
            marginTop: 20 
            }}>
            <Text style={{ fontFamily: 'outfit'}}>
                Password
            </Text>
            <TextInput
            secureTextEntry={true}
            style={styles.input}
            placeholder='Enter Password'></TextInput>
        </View>

    </View>

  )
}

const styles = StyleSheet.create({
  input: {
      padding: 15,
      borderWidth: 1,
      borderRadius: 15,
      borderColor: Colors.GRAY,
      fontFamily: 'outfit',
  }
})
