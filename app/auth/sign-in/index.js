import { View, Text, TextInput,StyleSheet } from 'react-native'
import React, { useEffect } from 'react'
import { useNavigation, useRouter } from 'expo-router'
import { Colors } from './../../../constants/Colors';
import { TouchableOpacity } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';

export default function SignIn() {

    const navigation = useNavigation();
    const router = useRouter();

    useEffect(() => {
        navigation.setOptions({
            headerShown: false
        })
    }, [])

  return (
    <View style={{ height: '100%',backgroundColor: Colors.WHITE }}>
    <View style={{
        padding: 25,
        marginTop: 40,
    }}>
        <TouchableOpacity onPress={() => router.back()}><Ionicons name="arrow-back" size={24} color="black" />
        </TouchableOpacity>
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

        <View style={{ 
            
            marginTop: 50, 
            backgroundColor: Colors.PRIMARY,
            padding: 20,
            borderRadius: 15
            }}>
            <Text style={{ 
                fontFamily: 'outfit',
                color: Colors.WHITE,
                textAlign: 'center' 

            }}>Sign In</Text>
        </View>


        <TouchableOpacity
            onPress={() => {
                router.replace('/auth/sign-up');
            }}
        style={{ 
            
            marginTop: 20, 
            backgroundColor: Colors.WHITE,
            padding: 20,
            borderRadius: 15,
            borderWidth: 1,
            }}>
            <Text style={{ 
                fontFamily: 'outfit',
                color: Colors.PRIMARY,
                textAlign: 'center' 

            }}>Create Account</Text>
        </TouchableOpacity>

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
