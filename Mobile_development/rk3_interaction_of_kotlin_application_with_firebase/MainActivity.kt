package com.example.kotlin_auth5_klicker_fb

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.Toast
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import android.widget.EditText
import androidx.core.widget.addTextChangedListener


class MainActivity : AppCompatActivity() {
    private lateinit var editText_00: EditText
    private lateinit var editText_01: EditText
    private lateinit var editText_02: EditText
    private lateinit var editText_10: EditText
    private lateinit var editText_11: EditText
    private lateinit var editText_12: EditText
    private lateinit var editText_20: EditText
    private lateinit var editText_21: EditText
    private lateinit var editText_22: EditText
    private val database = FirebaseDatabase.getInstance("https://mobile-5276e-default-rtdb.asia-southeast1.firebasedatabase.app/").reference
    private val Text_00 = database.child("a00")
    private val Text_01 = database.child("a01")
    private val Text_02 = database.child("a02")
    private val Text_10 = database.child("a10")
    private val Text_11 = database.child("a11")
    private val Text_12 = database.child("a12")
    private val Text_20 = database.child("a20")
    private val Text_21 = database.child("a21")
    private val Text_22 = database.child("a22")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        editText_00 = findViewById(R.id.editText_00)
        editText_01 = findViewById(R.id.editText_01)
        editText_02 = findViewById(R.id.editText_02)
        editText_10 = findViewById(R.id.editText_10)
        editText_11 = findViewById(R.id.editText_11)
        editText_12 = findViewById(R.id.editText_12)
        editText_20 = findViewById(R.id.editText_20)
        editText_21 = findViewById(R.id.editText_21)
        editText_22 = findViewById(R.id.editText_22)


        editText_00.addTextChangedListener { text ->
            Text_00.setValue(text.toString())
        }

        editText_01.addTextChangedListener { text ->
            Text_01.setValue(text.toString())
        }

        editText_02.addTextChangedListener { text ->
            Text_02.setValue(text.toString())
        }

        editText_10.addTextChangedListener { text ->
            Text_10.setValue(text.toString())
        }

        editText_11.addTextChangedListener { text ->
            Text_11.setValue(text.toString())
        }

        editText_12.addTextChangedListener { text ->
            Text_12.setValue(text.toString())
        }

        editText_20.addTextChangedListener { text ->
            Text_20.setValue(text.toString())
        }

        editText_21.addTextChangedListener { text ->
            Text_21.setValue(text.toString())
        }

        editText_22.addTextChangedListener { text ->
            Text_22.setValue(text.toString())
        }
    }
}
