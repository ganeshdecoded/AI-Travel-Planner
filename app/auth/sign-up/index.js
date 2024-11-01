import { View, Text, TextInput, StyleSheet} from 'react-native'
import React, { useEffect } from 'react'
import { useNavigation, useRouter } from 'expo-router';
import { Colors } from './../../../constants/Colors';
import { TouchableOpacity } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';


export default function SignUp() {

  const navigation = useNavigation();
  const router = useRouter();

  useEffect(() => {
    navigation.setOptions({
      headerShown: false
    })
  }, [])

  return (
    <View style={{ 
      padding: 25,
      backgroundColor: Colors.WHITE,
      height: '100%',
      paddingTop: 50,

      }}>

  <TouchableOpacity onPress={() => router.back()}><Ionicons name="arrow-back" size={24} color="black" />
  </TouchableOpacity>

      <Text style={{ 
        textAlign: 'center', 
        fontFamily: 'outfit-bold',
        fontSize: 30,
        marginTop: 20
        }}>Create New Account</Text>


<View style={{ 
            marginTop: 50 
            }}>
            <Text style={{ fontFamily: 'outfit' }}>
                Email
            </Text>
            <TextInput
            style={styles.input}
            placeholder='Enter Full Name'></TextInput>
        </View>

<View style={{ 
            marginTop: 20 
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

        <TouchableOpacity 
        
        style={{ 
            
            marginTop: 50, 
            backgroundColor: Colors.PRIMARY,
            padding: 20,
            borderRadius: 15
            }}>
            <Text style={{ 
                fontFamily: 'outfit',
                color: Colors.WHITE,
                textAlign: 'center' 

            }}>Create Account</Text>
        </TouchableOpacity>

        <TouchableOpacity 
        onPress={() => router.push('/auth/sign-in')}
        style={{ 
            
            marginTop: 20, 
            backgroundColor: Colors.WHITE,
            padding: 20,
            borderWidth: 1,
            borderRadius: 15
            }}>
            <Text style={{ 
                fontFamily: 'outfit',
                color: Colors.PRIMARY,
                textAlign: 'center' 

            }}>Sign In</Text>
        </TouchableOpacity>

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
