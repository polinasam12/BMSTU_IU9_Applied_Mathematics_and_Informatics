using System;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ConsoleApplication1
{
    class Library
    {

        private static SqlConnection? connection;

        private static DataSet? dataset;
        private static SqlDataAdapter? data_adapter;


        static public void connectToDB()
        {
            string connection_string = ConfigurationManager.ConnectionStrings["MsSqlServer"].ConnectionString;
            connection = new SqlConnection(connection_string);
            try
            {
                connection.Open();
                Console.WriteLine("Connection opened!");
            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
                Console.ReadKey();
                Environment.Exit(-1);
            }
        }

        static public bool isConnect()
        {
            return connection != null && connection.State != ConnectionState.Closed;
        }

        static public void disconnectToDB()
        {
            if (isConnect())
            {
                try
                {
                    connection.Close();
                    Console.WriteLine("Connection closed!");
                }
                catch (Exception ex)
                {
                    Console.Write(ex.Message);
                    Console.ReadKey();
                    Environment.Exit(-1);
                }
            }
        }

        static public void ShowTable(string table_name)
        {
            try
            {
                Console.WriteLine("----------------------------------------------------------------------------------------------------------------------------------------------------------------");
                using (SqlCommand cmd = connection.CreateCommand())
                {
                    cmd.Connection = connection;
                    //cmd.CommandText = "SELECT * FROM @table_name";
                    cmd.CommandText = "SELECT * FROM " + table_name;

                    SqlDataReader reader = cmd.ExecuteReader();

                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        if (reader.GetFieldType(i) == typeof(System.Int32))
                            Console.Write("{0,-16}", reader.GetName(i)); //+ "\t"
                        else Console.Write("{0,-33}", reader.GetName(i)); //+ "\t"
                    }
                    Console.WriteLine("\n----------------------------------------------------------------------------------------------------------------------------------------------------------------");

                    while (reader.Read())
                    {
                        for (int i = 0; i < reader.FieldCount; i++)
                        {

                            if (reader.GetFieldType(i) == typeof(System.Int32))
                                Console.Write("{0,-16}", reader.GetValue(i)); //+ "\t"

                            //else Console.Write("{0,-32}", reader.GetValue(i)); //+ "\t"
                            else Console.Write("{0,-33}", reader.IsDBNull(i) ? "-" : reader.GetValue(i));


                        }
                        Console.WriteLine();
                    }
                    Console.WriteLine("----------------------------------------------------------------------------------------------------------------------------------------------------------------");
                    reader.Close();
                }
            }
            catch (SqlException ex)
            {
                Console.Write(ex.Message);
                Console.ReadKey();
                Environment.Exit(-1);
            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
                Console.ReadKey();
                Environment.Exit(-1);
            }
        }


        static public void deleteBookByID(int Book_ID)
        {
            try
            {
                SqlCommand cmd = connection.CreateCommand();
                cmd.Connection = connection;
                cmd.CommandText = "DELETE FROM Books WHERE Book_ID = @book_id ";

                SqlParameter param = new SqlParameter();
                param.ParameterName = "@book_id";
                param.Value = Book_ID;
                param.SqlDbType = SqlDbType.Int;
                cmd.Parameters.Add(param);

                cmd.ExecuteNonQuery();
                Console.WriteLine("Book with Book_ID = " + Book_ID + " was deleted");

            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
                Console.ReadKey();
                Environment.Exit(-1);
            }
        }

        static public void deleteBookByIsbn(string ISBN)
        {
            try
            {
                SqlCommand cmd = connection.CreateCommand();
                cmd.Connection = connection;
                cmd.CommandText = "DELETE FROM Books WHERE ISBN = @isbn";

                SqlParameter param = new SqlParameter();
                param.ParameterName = "@isbn";
                param.Value = ISBN;
                param.SqlDbType = SqlDbType.NVarChar;
                cmd.Parameters.Add(param);


                cmd.ExecuteNonQuery();
                Console.WriteLine("Book with ISBN = \"" + ISBN + "\" was deleted");

            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
                Console.ReadKey();
                Environment.Exit(-1);
            }
        }


        static public void deleteAuthorByID(int Author_ID)
        {
            try
            {
                SqlCommand cmd = connection.CreateCommand();
                cmd.Connection = connection;
                cmd.CommandText = "DELETE FROM Books WHERE Author_ID = @author_id";

                SqlParameter param = new SqlParameter();
                param.ParameterName = "@author_id";
                param.Value = Author_ID;
                param.SqlDbType = SqlDbType.NVarChar;
                cmd.Parameters.Add(param);

                cmd.ExecuteNonQuery();
                Console.WriteLine("Author with Author_ID = " + Author_ID + " was deleted");

            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
                Console.ReadKey();
                Environment.Exit(-1);
            }
        }

        static public void deleteAuthorByFirstAndSurname(string Firstname, string Surname)
        {
            try
            {
                SqlCommand cmd = connection.CreateCommand();
                cmd.Connection = connection;
                cmd.CommandText = "DELETE FROM Authors WHERE Firstname = @firstname AND Surname = @surname";

                SqlParameter[] parametes = new SqlParameter[2];
                parametes[0] = new SqlParameter();
                parametes[0].ParameterName = "@firstname";
                parametes[0].Value = Firstname;
                parametes[0].SqlDbType = SqlDbType.NVarChar;

                parametes[1] = new SqlParameter();
                parametes[1].ParameterName = "@surname";
                parametes[1].Value = Surname;
                parametes[1].SqlDbType = SqlDbType.NVarChar;

                cmd.Parameters.AddRange(parametes);

                cmd.ExecuteNonQuery();
                Console.WriteLine("Author " + Firstname + " " + Surname + " was deleted");

            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
                Console.ReadKey();
                Environment.Exit(-1);
            }
        }





        static public void insertToBooks(int Author_ID, string ISBN, string Book_name, 
                                         string Publishing_house, int Year_of_issue, int Number_of_copies)
        {
            try
            {
                SqlCommand cmd = connection.CreateCommand();
                cmd.Connection = connection;

                cmd.CommandText = "INSERT INTO Books (Author_ID,ISBN,Book_name,Publishing_house,Year_of_issue,Number_of_copies)" +
                                  " VALUES (@author_id, @isbn, @book_name, " +
                                    "@publishing_house, @year_of_issue, @number_of_copies)";

                SqlParameter[] parametes = new SqlParameter[6];
                parametes[0] = new SqlParameter();
                parametes[0].ParameterName = "@author_id";
                parametes[0].Value = Author_ID;
                parametes[0].SqlDbType = SqlDbType.Int;

                parametes[1] = new SqlParameter();
                parametes[1].ParameterName = "@isbn";
                parametes[1].Value = ISBN;
                parametes[1].SqlDbType = SqlDbType.NVarChar;

                parametes[2] = new SqlParameter();
                parametes[2].ParameterName = "@book_name";
                parametes[2].Value = Book_name;
                parametes[2].SqlDbType = SqlDbType.NVarChar;

                parametes[3] = new SqlParameter();
                parametes[3].ParameterName = "@publishing_house";
                parametes[3].Value = Publishing_house;
                parametes[3].SqlDbType = SqlDbType.NVarChar;

                parametes[4] = new SqlParameter();
                parametes[4].ParameterName = "@year_of_issue";
                parametes[4].Value = Year_of_issue;
                parametes[4].SqlDbType = SqlDbType.Int;

                parametes[5] = new SqlParameter();
                parametes[5].ParameterName = "@number_of_copies";
                parametes[5].Value = Number_of_copies;
                parametes[5].SqlDbType = SqlDbType.Int;

                cmd.Parameters.AddRange(parametes);

                cmd.ExecuteNonQuery();
                Console.WriteLine("Book \"" + Book_name + "\" was inserted");

            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
                Console.ReadKey();
                Environment.Exit(-1);
            }
        }

        static public void updateBookNameByIsbn(string ISBN, string new_name)
        {
            try
            {
                SqlCommand cmd = connection.CreateCommand();
                cmd.Connection = connection;

                cmd.CommandText = "UPDATE Books SET Book_name = @new_name WHERE ISBN = @isbn";

                SqlParameter[] parametes = new SqlParameter[2];
                parametes[0] = new SqlParameter();
                parametes[0].ParameterName = "@new_name";
                parametes[0].Value = new_name;
                parametes[0].SqlDbType = SqlDbType.NVarChar;

                parametes[1] = new SqlParameter();
                parametes[1].ParameterName = "@isbn";
                parametes[1].Value = ISBN;
                parametes[1].SqlDbType = SqlDbType.NVarChar;


                cmd.Parameters.AddRange(parametes);


                cmd.ExecuteNonQuery();
                Console.WriteLine("Book with ISBN = \"" + ISBN + "\" was updated to new name: \"" + new_name + "\"");


            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
                Console.ReadKey();
                Environment.Exit(-1);
            }
        }

        static public void configDiscon()
        {
            dataset = new DataSet();
            data_adapter = new SqlDataAdapter("SELECT * FROM Authors", connection);
            data_adapter.Fill(dataset, "Authors");
            data_adapter = new SqlDataAdapter("SELECT * FROM Books", connection);
            data_adapter.Fill(dataset, "Books");


        }

        static public void showDiscon(string table_name)
        {
            Console.Write("\n");
            Console.WriteLine("Disconnected table: " + table_name);
            ShowTable(table_name);
        }

        static public void showCon(string table_name)
        {
            Console.Write("\n");
            Console.WriteLine("Connected table: " + table_name);
            ShowTable(table_name);
        }


        static public void deleteBooksByIsbnDiscon(string ISBN)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "DELETE FROM Books WHERE ISBN = @isbn";

            cmd.Parameters.Add("@isbn", SqlDbType.NVarChar, 0, "ISBN");


            data_adapter.DeleteCommand = cmd;

            for (int i = 0; i < dataset.Tables["Books"].Rows.Count; i++)
            {
                DataRow row = dataset.Tables["Books"].Rows[i];
                if (row["ISBN"].Equals(ISBN))
                {
                    row.Delete();
                }
            }



            data_adapter.Update(dataset, "Books");
            Console.WriteLine("Book with ISBN  \"" + ISBN + "\" was deleted");
        }

        //------------------------------------------------------------------------
        static public void deleteAuthorByIdDiscon(int Author_ID)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "DELETE FROM Authors WHERE Author_ID = @author_id";

            cmd.Parameters.Add("@author_id", SqlDbType.Int, 0, "Author_ID");

            data_adapter.DeleteCommand = cmd;

            for (int i = 0; i < dataset.Tables["Authors"].Rows.Count; i++)
            {
                DataRow row = dataset.Tables["Authors"].Rows[i];
                if (row["Author_ID"].Equals(Author_ID))
                {
                    row.Delete();
                }
            }

            data_adapter.Update(dataset, "Authors");
            Console.WriteLine("Author with Author_ID =  " + Author_ID + " was deleted");
        }
        //------------------------------------------------------------------------



        static public void insertToBooksDiscon(int Author_ID, string ISBN, 
                                               string Book_name, string Publishing_house, 
                                               int Year_of_issue, int Number_of_copies)
        {

            SqlCommand cmd = connection.CreateCommand();
            cmd.Connection = connection;
            cmd.CommandText = "INSERT INTO Books(Author_ID,ISBN,Book_name," +
                                          "Publishing_house,Year_of_issue,Number_of_copies)" +
                "VALUES (@author_id,@isbn,@book_name," +
                         "@publishing_house,@year_of_issue,@number_of_copies)";

            cmd.Parameters.Add("@author_id", SqlDbType.Int, 0, "Author_ID");
            cmd.Parameters.Add("@isbn", SqlDbType.NVarChar, 0, "ISBN");
            cmd.Parameters.Add("@book_name", SqlDbType.NVarChar, 0, "Book_name");
            cmd.Parameters.Add("@publishing_house", SqlDbType.NVarChar, 0, "Publishing_house");
            cmd.Parameters.Add("@year_of_issue", SqlDbType.Int, 0, "Year_of_issue");
            cmd.Parameters.Add("@number_of_copies", SqlDbType.Int, 0, "Number_of_copies");


            data_adapter.InsertCommand = cmd;

            DataRow dataRow = dataset.Tables["Books"].NewRow();
            dataRow["Author_ID"] = Author_ID;
            dataRow["ISBN"] = ISBN;
            dataRow["Book_name"] = Book_name;
            dataRow["Publishing_house"] = Publishing_house;
            dataRow["Year_of_issue"] = Year_of_issue;
            dataRow["Number_of_copies"] = Number_of_copies;

            dataset.Tables["Books"].Rows.Add(dataRow);
            data_adapter.Update(dataset, "Books");
            Console.WriteLine("Book with ISBN  \"" + ISBN + " and Book name \"" + Book_name + "\" was inserted");

        }

        static public void updateBooksByIdDiscon(int Book_ID, int Author_ID, string ISBN,
                                               string Book_name, string Publishing_house,
                                               int Year_of_issue, int Number_of_copies)
        {
            SqlCommand cmd = connection.CreateCommand();
            cmd.Connection = connection;


            cmd.CommandText = "UPDATE Books SET " +
                "Author_ID = @author_id, " +
                "ISBN = @isbn, " +
                "Book_name = @book_name, " +
                "Publishing_house = @publishing_house, " +
                "Year_of_issue = @year_of_issue, " +
                "Number_of_copies = @number_of_copies " +
                "WHERE Book_ID = @book_id";

            cmd.Parameters.Add("@book_id", SqlDbType.Int, 0, "Book_ID");
            cmd.Parameters.Add("@author_id", SqlDbType.Int, 0, "Author_ID");
            cmd.Parameters.Add("@isbn", SqlDbType.NVarChar, 0, "ISBN");
            cmd.Parameters.Add("@book_name", SqlDbType.NVarChar, 0, "Book_name");
            cmd.Parameters.Add("@publishing_house", SqlDbType.NVarChar, 0, "Publishing_house");
            cmd.Parameters.Add("@year_of_issue", SqlDbType.Int, 0, "Year_of_issue");
            cmd.Parameters.Add("@number_of_copies", SqlDbType.Int, 0, "Number_of_copies");

            data_adapter.UpdateCommand = cmd;

            for (int i = 0; i < dataset.Tables["Books"].Rows.Count; i++)
            {
                DataRow row = dataset.Tables["Books"].Rows[i];

                if (row["Book_ID"].Equals(Book_ID))
                {
                    Console.WriteLine("Book_ID " + Book_ID + " \"" + row["Book_name"] + "\" was updated to \"" + Book_name + "\"");
                    row["Author_ID"] = Author_ID;
                    row["ISBN"] = ISBN;
                    row["Book_name"] = Book_name;
                    row["Publishing_house"] = Publishing_house;
                    row["Year_of_issue"] = Year_of_issue;
                    row["Number_of_copies"] = Number_of_copies;
                    
                }
            }

            data_adapter.Update(dataset, "Books");




            

        }



    }
    class Program
    {
        static void Main(string[] args)
        {
            Library.connectToDB();
            Console.WriteLine(Library.isConnect());

            //// Связный уровень //
            Console.WriteLine("---------- Connected Layer ----------");
            Library.showCon("Books");

            Console.Write("\n\n\n");
            Console.WriteLine("---------- Insert ----------");
            Library.insertToBooks(8, "942-5-26-005211-4", "The Adventure of Sherlock Holmes", "XYZ", 2001, 15);
            Library.showCon("Books");

            Console.Write("\n\n\n");
            Console.WriteLine("---------- Update ----------");
            Library.updateBookNameByIsbn("945-5-06-005411-4", "The Hound of the Baskervilles");
            Library.showCon("Books");


            Console.Write("\n\n\n");
            Console.WriteLine("---------- Delete ----------");
            Library.deleteBookByID(2);
            Library.deleteBookByIsbn("214-1-26-102611-5");
            Library.showCon("Books");

            Console.Write("\n\n\n");
            Console.WriteLine("----------Deleting from authors and cascading Deleting from books----------");
            Library.deleteAuthorByFirstAndSurname("Arthur", "Conan Doyle");
            Library.showCon("Authors");
            Library.showCon("Books");



            



            //// Несвязный уровень //
            Console.Write("\n\n\n");
            Console.WriteLine("----------Disconnected Layer----------");
            Library.configDiscon();
            Library.showDiscon("Books");


            Console.Write("\n\n\n");
            Console.WriteLine("------------------Insert Disconnected--------------");
            Library.insertToBooksDiscon(1, "343-3-43-005543-3", "Anna Karenina", "Asdf Qwerty", 2022, 18);
            Library.insertToBooksDiscon(3, "876-4-43-788765-1", "The Night Before Christmas", "Abcdef", 1990, 34);
            Library.showDiscon("Books");


            Console.Write("\n\n\n");
            Console.WriteLine("------------------Update Disconnected--------------");
            Library.updateBooksByIdDiscon(1, 3, "111-1-11-111111-1", "Viy", "Eksmo", 2022, 18); ;
            Library.showDiscon("Books");

            
            Console.Write("\n\n\n");
            Console.WriteLine("------------------Delete Disconnected--------------");
            Library.deleteBooksByIsbnDiscon("343-3-43-005543-3");
            Library.showDiscon("Books");


            Console.Write("\n\n\n");
            Console.WriteLine("------------------Delete Discon Author and cascading deleting books --------------");
            Library.showDiscon("Authors");
            Library.showDiscon("Books");
            Library.deleteAuthorByIdDiscon(1);
            Library.deleteAuthorByIdDiscon(2);
            Library.deleteAuthorByIdDiscon(3);
            Library.deleteAuthorByIdDiscon(7);
            Library.showDiscon("Authors");
            Library.showDiscon("Books");




            Library.disconnectToDB();
            //Console.ReadKey();
        }
    }
}
