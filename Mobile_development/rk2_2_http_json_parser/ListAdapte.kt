package com.example.httpjson

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.Toast
import androidx.appcompat.widget.AppCompatTextView

class ListAdapte (val context: Context, val list: ArrayList<Jquery>) : BaseAdapter() {
    override fun getCount(): Int {
        return list.size
    }

    override fun getItem(position: Int): Any {
        return list[position]
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    @SuppressLint("MissingInflatedId", "ViewHolder")
    override fun getView(position: Int, countertView: View?, parent: ViewGroup?): View {

        val view: View = LayoutInflater.from(context).inflate(R.layout.row_layout,parent,false)
        val jqueryVersion = view.findViewById(R.id.jquery_version) as AppCompatTextView
        val jqueryReleaseDate = view.findViewById(R.id.jquery_releaseDate) as AppCompatTextView
        val jqueryLatestUpdate = view.findViewById(R.id.jquery_latestUpdate) as AppCompatTextView
        val jquerySize = view.findViewById(R.id.jquery_size) as AppCompatTextView
        val jqueryNotes = view.findViewById(R.id.jquery_notes) as AppCompatTextView
        val jqueryId = view.findViewById(R.id.jquery_id) as AppCompatTextView

        jqueryVersion.text = list[position].version.toString()
        jqueryReleaseDate.text = list[position].releaseDate
        jqueryLatestUpdate.text = list[position].latestUpdate
        jquerySize.text = list[position].size
        jqueryNotes.text = list[position].notes
        jqueryId.text = list[position].id.toString()

        view.setOnClickListener({
            Toast.makeText(context, "Version: ${jqueryVersion.text}\nReleaseDate: ${jqueryReleaseDate.text}\nLatestUpdate: ${jqueryLatestUpdate.text}\nSize: ${jquerySize.text}\nNotes: ${jqueryNotes.text}\nId: ${jqueryId.text}" , Toast.LENGTH_SHORT).show()
        })

        return view
    }
}
