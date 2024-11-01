import { View, Text,Image,StyleSheet, TouchableOpacity } from 'react-native'
import React from 'react'
import { Colors } from '@/constants/Colors'
import { useRouter } from 'expo-router'

export default function Login() {

    const router = useRouter();

  return (
    <View>
      <Image 
        source={require('../assets/images/LoginSplash.jpg')}
        style={{
            width: '100%',
            height: '40%',
        }}
        />

        <View style={styles.container}  >
            <Text
            style={{
                fontFamily: 'outfit-bold',
                fontSize: 30,
                marginTop: 20,
                textAlign: 'center'
            }}
            >AI Travel Planner</Text>

            <Text style={{
                fontFamily: 'outfit',
                fontSize: 18,
                textAlign: 'center',
                marginTop: 20,
                color: Colors.GRAY
            }
            }>
                Discover new adventure effortlessly.Personalised itineraries at your fingertips.Travel smarter with AI Driven insights
            </Text>

            <TouchableOpacity style={styles.button}
                onPress={() => router.push('/auth/sign-in')}
            >
                <Text style={{color: Colors.WHITE,
                    textAlign: 'center',
                    fontFamily: 'outfit',
                    fontSize: 18
                }}>
                    Sign In With Google
                </Text>
            </TouchableOpacity>

        </View>

    </View>
  )
}

const styles = StyleSheet.create({
    container: {
        backgroundColor: Colors.WHITE,
        borderTopLeftRadius: 30,
        borderTopRightRadius: 30,
        marginTop: -20,
        padding: 25,
        height: '100%'
    },
    button:{
        padding: 15,
        backgroundColor: Colors.PRIMARY,
        borderRadius: 99,
        marginTop:'20%'
    }
})
