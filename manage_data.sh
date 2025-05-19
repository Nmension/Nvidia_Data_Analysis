#!/bin/bash
PSQL="psql -X --username=postgres --dbname=nvidia -t --no-align -c"

MAIN_MENU() { 
  until [[ (! -z $CHOICE) && $CHOICE =~ ^[0-9]$ ]]
  do
    if [[ $1 ]]
    then
      echo -e "\n$1"
    else
      echo -e "\nWelcome to the nvidia database management script! What would you like to do?"
    fi
    echo -e "1. Edit the database.\n2. Auto-update remaining tables from existing reports data.\n3. Export some data."
    read CHOICE

    case $CHOICE in
      1) INSERTION_MENU ;;
      2) AUTO_UPDATE ;;
      3) EXPORT_MENU ;;
      #recall the func if the input is not a valid number with a second arg
      *) MAIN_MENU "I could not find that option. Please try again with a valid input." ;;
    esac
  done
}
INSERTION_MENU() {
  echo -e "\nWould you like to:\n1. insert new data? \n2. update existing data?"
  read CHOICE2
  case $CHOICE2 in
    1)  echo -e "\nAre you interested in:\n1. inserting data only in specific columns?\n2. inserting data for all the columns of a table?"
        read CHOICE3
        if [[ $CHOICE3 == 1 ]]
        then
          echo -e "\nList of existing tables:"
          T_LIST=$($PSQL "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';")
          echo "$T_LIST" | while read TABLES
          do
            echo "$TABLES" 
          done
          echo -e "From the list above, insert the name of the table you are interested in:"
          read CHOICE4
          if [[ ! "${T_LIST[*]}" =~ $CHOICE4  ]] 
          then
            echo -e "\nThe selected table name doesn't exist. Please make sure to insert its name exactly as it is in the list above."
          else
            COL_LIST=$(psql -X -U postgres -d nvidia -c "SELECT column_name FROM information_schema.columns WHERE table_name = '$CHOICE4'; ")
            echo -e "\nList of columns in $CHOICE4:"
            echo "$COL_LIST" | while read COLUMN 
            do
              if [[ ! ( ( "${COLUMN[*]}" =~ "column_name" ) || ( "${COLUMN[*]}" =~ "-------------" ) || ( "${COLUMN[*]}" =~ (row)+ ) ) ]]
              then
                echo "$COLUMN"
              fi
            done
            echo -e "\nFrom the list above, insert the name(s) of the column(s) you want in $CHOICE4 table separated by commas ','\nsuch as: col_name_1, col_name_2, col_name_3 ..."
            read COL_NAM
            echo -e "\nInsert the values of the selected columns: $COL_NAM, row by row, by strictly following this synthax:\n(col_1_value_1, col_2_value_1, col_3_value_1, ...),(col_1_value_2, col_2_value_2, col_3_value_2, ...) \nfor two rows with 3 columns, so 3 values, in this example"
            read VALS
            $($PSQL "INSERT INTO $CHOICE4($COL_NAM) VALUES$VALS")

          fi
        else
          echo -e "\nList of existing tables:"
          T_LIST=$($PSQL "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';")
          echo "$T_LIST" | while read TABLES
          do
            echo "$TABLES" 
          done
          echo -e "From the list above, insert the name of the table you are interested in:"
          read CHOICE4
          if [[ ! "${T_LIST[*]}" =~ $CHOICE4  ]] 
          then
            echo -e "\nThe selected table name doesn't exist. Please make sure to insert its name exactly as it is in the list above."
          else
            ONLY_COLS=()
            COL_LIST=$(psql -X -U postgres -d nvidia -c "SELECT column_name FROM information_schema.columns WHERE table_name = '$CHOICE4'; ")
            echo -e "\nList of columns in $CHOICE4:"
            echo "$COL_LIST" | while read COLUMN 
            do
              if [[ ! ( ( "${COLUMN[*]}" =~ "column_name" ) || ( "${COLUMN[*]}" =~ "-------------" ) || ( "${COLUMN[*]}" =~ (row)+ ) ) ]]
              then
                echo "$COLUMN"
                ONLY_COLS+=("$COLUMN")
                ONLY_COLS+=(",")
              fi
            done
            echo -e "\nInsert the values of the columns from $CHOICE4, row by row, with the same number of entries per row as there are columns, by strictly following this synthax:\n(col_1_value_1, col_2_value_1, col_3_value_1, ...),(col_1_value_2, col_2_value_2, col_3_value_2, ...) \nfor two rows with 3 columns in this example"
            read VALS
            $($PSQL "INSERT INTO $CHOICE4($ONLY_COLS) VALUES$VALS;")
          fi
        fi ;;

    2)  echo -e "\nList of existing tables:"
        T_LIST=$($PSQL "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';")
        echo "$T_LIST" | while read TABLES
        do
          echo "$TABLES" 
        done
        echo -e "\nFrom the list above, insert the name of the table you are interested to update:"
        read CHOICE4
        if [[ ! "${T_LIST[*]}" =~ $CHOICE4  ]] 
        then
          echo -e "\nThe selected table name doesn't exist. Please make sure to insert its name exactly as it is in the list above."
        else
          COL_LIST=$(psql -X -U postgres -d nvidia -c "SELECT column_name,data_type FROM information_schema.columns WHERE table_name = '$CHOICE4'; ")
          echo -e "\nList of columns with their respective data types in $CHOICE4:"
          echo "$COL_LIST" | while read COLUMN 
          do
            if [[ ! ( ( "${COLUMN[*]}" =~ "-------------" ) || ( "${COLUMN[*]}" =~ (row)+ ) ) ]]
            then
              echo "$COLUMN"
            fi
          done
          echo -e "\nInsert the number of columns to update:"
          read CHOICE5
          case $CHOICE5 in
            1)  echo -e "\nFrom the list above, insert the name of the column you want to update in the $CHOICE4 table:"
                read COL_NAM
                echo -e "\nIf the value is a number, directly insert it as it is but if it is any type of string such as 'VARCHAR', insert it between quotes, such as: 'Value'\nNow, insert the value of the selected column:"
                read VAL
                echo -e "\nNow you will select a condition to precisely update the value of a row, firstly,\ninsert the name of a column where a certain value has to be updated:"
                read CON_COL
                echo -e "\nSecondly, insert that certain value for the $COND_COL:"
                read COND_VAL
                $($PSQL "UPDATE $CHOICE4 SET $COL_NAM=$VAL WHERE $COND_COL=$COND_VAL;") ;;
            2)  echo -e "\nFrom the list above, insert the name of the first column you want to update in the $CHOICE4 table:"
                read COL_NAM1
                echo -e "\nInsert the name of the second column you want to update in the $CHOICE4 table:"
                read COL_NAM2
                echo -e "\nIf the value is a number, directly insert it as it is but if it is any type of string such as 'VARCHAR', insert it between quotes, such as: 'Value'\nNow, insert the value of the first selected column:"
                read VAL1
                echo -e "Now, insert the value of the second selected column:"
                read VAL2
                echo -e "\nNow you will select a condition to precisely update the value of a row, firstly,\ninsert the name of a column where a certain value has to be updated:"
                read CON_COL
                echo -e "\nSecondly, insert that certain value for the $COND_COL:"
                read COND_VAL
                $($PSQL "UPDATE $CHOICE4 SET $COL_NAM1=$VAL1,$COL_NAM2=$VAL2 WHERE $COND_COL=$COND_VAL;") ;;
            3)  echo -e "\nFrom the list above, insert the name of the first column you want to update in the $CHOICE4 table:"
                read COL_NAM1
                echo -e "\nInsert the name of the second column to update:"
                read COL_NAM2
                echo -e "\nInsert the name of the third column to update:"
                read COL_NAM3
                echo -e "\nIf the value is a number, directly insert it as it is but if it is any type of string such as 'VARCHAR', insert it between quotes, such as: 'Value'\nNow, insert the value of the first selected column:"
                read VAL1
                echo -e "Now, insert the value of the second selected column:"
                read VAL2
                echo -e "Now, insert the value of the third selected column:"
                read VAL3
                echo -e "\nNow you will select a condition to precisely update the value of a row, firstly,\ninsert the name of a column where a certain value has to be updated:"
                read CON_COL
                echo -e "\nSecondly, insert that certain value for the $COND_COL:"
                read COND_VAL
                $($PSQL "UPDATE $CHOICE4 SET $COL_NAM1=$VAL1,$COL_NAM2=$VAL2,$COL_NAM3=$VAL3 WHERE $COND_COL=$COND_VAL;") ;;
            4)  echo -e "\nFrom the list above, insert the name of the first column you want to update in the $CHOICE4 table:"
                read COL_NAM1
                echo -e "\nInsert the name of the second column to update:"
                read COL_NAM2
                echo -e "\nInsert the name of the third column to update:"
                read COL_NAM3
                echo -e "\nInsert the name of the fourth column to update:"
                read COL_NAM4
                echo -e "\nIf the value is a number, directly insert it as it is but if it is any type of string such as 'VARCHAR', insert it between quotes, such as: 'Value'\nNow, insert the value of the first selected column:"
                read VAL1
                echo -e "\nNow, insert the value of the second selected column:"
                read VAL2
                echo -e "\nNow, insert the value of the third selected column:"
                read VAL3
                echo -e "\nNow, insert the value of the fourth selected column:"
                read VAL4
                echo -e "\nNow you will select a condition to precisely update the value of a row, firstly,\ninsert the name of a column where a certain value has to be updated:"
                read CON_COL
                echo -e "\nSecondly, insert that certain value for the $COND_COL:"
                read COND_VAL
                $($PSQL "UPDATE $CHOICE4 SET $COL_NAM1=$VAL1,$COL_NAM2=$VAL2,$COL_NAM3=$VAL3,$COL_NAM4=$VAL4 WHERE $COND_COL=$COND_VAL;") ;;
            *)  echo -e "\nSorry, only updating up to four columns simultaneously is handled..." ;;
          esac
        fi ;;
    *)  echo -e "Error 404: not found, please input a valid number among the proposed choices." ;;
  esac

}

AUTO_UPDATE() { 
  #latest quarterly year id in the DB
  YQ_ID_MAX=$($PSQL "SELECT MAX(yq_id) FROM quarterly_financials;")
  #var for checking if the latest quarterly year id in the DB has a value ammong the not given data from the financial reports
  COMPLETE_DQ=$($PSQL "SELECT taxes_and_interests FROM quarterly_financials WHERE yq_id=$YQ_ID_MAX;")
  #check if the COMPLETE DQ var is empty
  if [[ -z $COMPLETE_DQ ]]
  then
    YQ_ID=$($PSQL "SELECT MIN(yq_id) FROM quarterly_financials;")
    #instanciate the DB_ID var so that it isn't empty from the beginning
    DB_ID=$($PSQL "SELECT yq_id FROM quarterly_financials WHERE yq_id=$YQ_ID;")
    #check for when the DB_ID var becomes empty, implying that YQ_ID has run out of range in the loop
    until [[ -z $DB_ID ]]
    do
      #calc first part of empty col data in quarterly table
      TAX_INTQ=$($PSQL "SELECT operating_income - net_income FROM quarterly_financials WHERE yq_id=$YQ_ID;")
      COGS_Q=$($PSQL "SELECT ROUND(revenue - gross_margin_percentage / 100 * revenue) FROM quarterly_financials WHERE yq_id=$YQ_ID;")
      #first update of the table to calc the remaining missing data
      UP1_QF_DATA=$($PSQL "UPDATE quarterly_financials SET taxes_and_interests = $TAX_INTQ, cost_of_goods_sold = $COGS_Q WHERE yq_id=$YQ_ID;")
      #calc the remaining cols from the existing data
      GROSS_PQ=$($PSQL "SELECT revenue - cost_of_goods_sold FROM quarterly_financials WHERE yq_id=$YQ_ID;")
      COGS_OPEX_DIF=$($PSQL "SELECT operating_expenses - cost_of_goods_sold FROM quarterly_financials WHERE yq_id=$YQ_ID;")
      #second update of the table to calc the remaining missing data
      UPDATE_QF_DATA=$($PSQL "UPDATE quarterly_financials SET gross_profit = $GROSS_PQ, cogs_opex_difference = $COGS_OPEX_DIF WHERE yq_id=$YQ_ID;")
      echo "Updated missing data into the 'quarterly_financials' table for $YQ_ID..."
      #increment YQ_ID
      ((  YQ_ID++ ))
      #within the loop, recal the DB_ID var to check if YQ_ID is still in range
      DB_ID=$($PSQL "SELECT yq_id FROM quarterly_financials WHERE yq_id=$YQ_ID;")
    done
  else
    #if the selected col among the missing data for the latest quarterly year id exists, print message
    echo -e "\nQuarterly financials are up to date!"
  fi

  #vars to get all years in the table
  YR=$($PSQL "SELECT MIN(year) FROM quarterly_financials JOIN quarters_per_year USING(yq_id);")
  QY_MAX=$($PSQL "SELECT MAX(year) FROM quarterly_financials JOIN quarters_per_year USING(yq_id);")
  LATEST_ENTRY_YF=$($PSQL "SELECT year FROM yearly_financials WHERE year=$QY_MAX;")
  if [[ -z $LATEST_ENTRY_YF ]]
  then
    until [[ $YR -gt $QY_MAX ]]
    do
      #yearly financial table operations
      REVENUE_Y=$($PSQL "SELECT SUM(revenue) FROM quarterly_financials FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YR;")
      OPIN_Y=$($PSQL "SELECT SUM(operating_income) FROM quarterly_financials FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YR;")
      NETIN_Y=$($PSQL "SELECT SUM(net_income) FROM quarterly_financials FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YR;")
      GROSS_MARG_Y=$($PSQL "SELECT AVG(gross_margin_percentage) FROM quarterly_financials FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YR;")
      TAX_INT_Y=$($PSQL "SELECT SUM(taxes_and_interests) FROM quarterly_financials FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YR;")
      COGS_Y=$($PSQL "SELECT SUM(cost_of_goods_sold) FROM quarterly_financials FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YR;")
      GROSS_P_Y=$($PSQL "SELECT SUM(gross_profit) FROM quarterly_financials FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YR;")
      OPEX_Y=$($PSQL "SELECT SUM(operating_expenses) FROM quarterly_financials FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YR;")
      COGS_OPEX_D_Y=$($PSQL "SELECT SUM(cogs_opex_difference) FROM quarterly_financials FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YR;")
      #insert all the corresponding data into the yf table
      DATA_YF=$($PSQL "INSERT INTO yearly_financials(year, revenue, operating_income, net_income, gross_margin_percentage, taxes_and_interests, cost_of_goods_sold, gross_profit, operating_expenses, cogs_opex_difference) VALUES($YR,$REVENUE_Y,$OPIN_Y,$NETIN_Y,$GROSS_MARG_Y,$TAX_INT_Y,$COGS_Y,$GROSS_P_Y,$OPEX_Y,$COGS_OPEX_D_Y);")
      #increment for the next row
      echo "Inserted missing data into the 'yearly_financials' table for $YR..."
      (( YR++ ))
    done
  else
    #print message when latest entry year already exists
    echo -e "\nYearly financials are up to date!"
  fi
  #check for the latest year in the QRPA table and see if it corresponds in the yrpa table
  Y_MAX=$($PSQL "SELECT MAX(year) FROM quarterly_revenue_per_activity FULL JOIN quarters_per_year USING(yq_id);")
  LATEST_ENTRY_YFPA=$($PSQL "SELECT year FROM yearly_revenue_per_activity WHERE year=$Y_MAX;")
  #Check if the latest entry in QRPA table isn't yet in YRPA
  if [[ -z $LATEST_ENTRY_YFPA ]]
  then
    #get starting data entry year
    YEAR=$($PSQL "SELECT MIN(year) FROM quarterly_revenue_per_activity FULL JOIN quarters_per_year USING(yq_id);")
    #get the id of the first activity as current activity
    A_ID=$($PSQL "SELECT MIN(activity_id) FROM quarterly_revenue_per_activity;")
    #get the id of the last activity
    A_MAX=$($PSQL "SELECT MAX(activity_id) FROM quarterly_revenue_per_activity;")
    #loop until the YEAR var has surpassed the max existing year in the QRPA table
    until [[ $YEAR -gt $Y_MAX ]]
    do
      #check if the current activity id is bellow or equal the latest activity id
      if [[ $A_ID -le $A_MAX ]]
      then
        #sum per year per activity and insert into the YRPA table
        SUM_Y=$($PSQL "SELECT SUM(ammount) FROM quarterly_revenue_per_activity FULL JOIN quarters_per_year USING(yq_id) WHERE year=$YEAR AND activity_id=$A_ID;")
        INSERT_SUM_Y=$($PSQL "INSERT INTO yearly_revenue_per_activity(year, activity_id, ammount) VALUES($YEAR, $A_ID, $SUM_Y);")
        #pass to the next activity without changing year
        (( A_ID++ ))
      else
        echo "Added sums for $YEAR from the 'quarterly_revenue_per_activity' table into the 'yearly_revenue_per_activity'..."
        #change year only if the current activity id is out of range and reset the id back to the first activity
        ((  YEAR++ ))
        A_ID=$($PSQL "SELECT MIN(activity_id) FROM quarterly_revenue_per_activity;")
      fi
    done
  else
    #print message when the latest year's entry already exists in the DB
    echo -e "\nYearly revenues per activity are up to date!"
  fi

  V_YR=$($PSQL "SELECT MIN(year) FROM shares_numbers_in_million;")
  SHARES_NUMB_YMAX=$($PSQL "SELECT MAX(year) FROM shares_numbers_in_million;")
  VY_DATA=$($PSQL "SELECT year FROM valuations WHERE year=$SHARES_NUMB_YMAX;")
  if [[ -z $VY_DATA ]]
  then
    until [[ $V_YR -gt $SHARES_NUMB_YMAX ]]
    do
      INS_Y=$($PSQL "INSERT INTO valuations(year) VALUES($V_YR);")
      #calc market cap
      MARK_CAP=$($PSQL "SELECT total_outstanding * average_stock_price FROM shares_numbers_in_million FULL JOIN yearly_financials_extra USING(year) WHERE year=$V_YR;")
      #insert mark_cap
      INSERT_MC=$($PSQL "UPDATE valuations SET average_market_cap = $MARK_CAP WHERE year=$V_YR;")
      #calc enterprise value
      ENT_VAL=$($PSQL "SELECT average_market_cap + total_debt - cash_and_cash_equivalents FROM yearly_financials_extra FULL JOIN valuations USING(year) WHERE year=$V_YR;")
      #insert enterprise_value
      INSERT_EV=$($PSQL "UPDATE valuations SET enterprise_value = $ENT_VAL WHERE year=$V_YR;")
      #calc equity value per share
      EQ_VAL_PS=$($PSQL "SELECT ( enterprise_value - net_debt ) / total_outstanding FROM shares_numbers_in_million FULL JOIN yearly_financials_extra USING(year) FULL JOIN valuations USING(year) WHERE year=$V_YR;")
      #insert data into the table 
      INSERT_EQVPS=$($PSQL "UPDATE valuations SET equity_value_per_share= $EQ_VAL_PS WHERE year=$V_YR;")
      echo "Calculated and updated valuations data for $V_YR..."
      (( V_YR++ ))
    done
  else
    echo -e "\nValuations are up to date!"
  fi
  echo -e "\nData update successful! Don't forget to reward my work with a star on my GitHub: Nmension"
}

EXPORT_MENU() {
  echo -e "\nSelect select an option among those bellow:"
  echo -e "\n1. All the data from one or more tables.\n2. Data from specific columns in a table or more."
  read CHOICE2

  TABLES() {
    echo -e "\nList of existing tables:"
    T_LIST=$($PSQL "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';")
    echo "$T_LIST" | while read TABLES
    do
      echo "$TABLES" 
    done
    echo -e "\nHow many tables from the list would you like your data exported from ?"
    read CHOICE3
    case $CHOICE3 in
      1)  echo -e "\nFrom the list above, insert the name of the table you would like your data from:" 
          read CHOICE4 
          if [[ ! "${T_LIST[*]}" =~ $CHOICE4  ]] 
          then
           echo -e "\nThe selected table name doesn't exist. Please make sure to insert its name exactly as it is in the list above."
          else
           echo -e "\nInsert the desired file name (without its .format suffix):"
           read FILENAME
           $(psql -X --csv -U postgres -d nvidia -c "SELECT * FROM $CHOICE4" > $FILENAME.csv)
           echo -e "\nData exportation successful! Don't forget to reward my work with a star on my GitHub: Nmension"
          fi ;;
      2)  echo -e "\nFrom the list above, insert the name of the first table you would like your data from:" 
          read CHOICE4
          if [[ ! "${T_LIST[*]}" =~ $CHOICE4  ]] 
          then
            echo "The first selected table name doesn't exist. Please make sure to insert its name exactly as it is in the list above."
          else
            echo -e "\nName of the second table:"
            read CHOICE5
            if [[ ! "${T_LIST[*]}" =~ $CHOICE5  ]]
            then
              echo "The second selected table name doesn't exist. Please make sure to insert its name exactly as it is in the list above."
            else
              COL_LIST_T1=$(psql -X -U postgres -d nvidia -c "SELECT column_name FROM information_schema.columns WHERE table_name = '$CHOICE4';")
              COL_LIST_T2=$(psql -X -U postgres -d nvidia -c "SELECT column_name FROM information_schema.columns WHERE table_name = '$CHOICE5';")
              echo -e "\nInsert the desired file name (without its .format suffix):"
              read FILENAME
              echo "$COL_LIST_T1" | while read COLUMN_T1 
              do
                if [[ "${COL_LIST_T2[*]}" =~ $COLUMN_T1 && ! ( ( "${COLUMN_T1[*]}" =~ "column_name" ) || ( "${COLUMN_T1[*]}" =~ "-------------" ) || ( "${COLUMN_T1[*]}" =~ (row)+ ) ) ]]
                then
                  COMMON_COL=$COLUMN_T1
                  $(psql -X --csv -U postgres -d nvidia -c "SELECT * FROM $CHOICE4 FULL JOIN $CHOICE5 USING($COMMON_COL);" > $FILENAME.csv)
                  echo -e "\nData exportation successful! Don't forget to reward my work with a star on my GitHub: Nmension"
                fi
              done
            fi
          fi ;;
      *)  echo -e "\nFor 3 tables or more, I am going to assist you in creating the required query for the data you want to export."
          echo -e "\nList of existing tables:"
          T_LIST=$($PSQL "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';")
          echo "$T_LIST" | while read TABLES
          do
            echo "$TABLES" 
          done
          until [[ $CHOICE4 =~ "ok" ]]
          do
            echo -e "\nFirst, check the columns in each table you want by inserting its name as in the list above:\nWhen you knows which tables you want, insert 'ok' instead."
            read CHOICE4 
            if [[ ! "${T_LIST[*]}" =~ $CHOICE4  ]] 
            then
              echo "The selected table name doesn't exist. Please make sure to insert its name exactly as it is in the table list above."
            else
              COL_LIST=$(psql -X -U postgres -d nvidia -c "SELECT column_name FROM information_schema.columns WHERE table_name = '$CHOICE4'; ")
              echo -e "\nList of columns in $CHOICE4:"
              echo "$COL_LIST" | while read COLUMN 
              do
                if [[ ! ( ( "${COLUMN[*]}" =~ "column_name" ) || ( "${COLUMN[*]}" =~ "-------------" ) || ( "${COLUMN[*]}" =~ (row)+ ) ) ]]
                then
                  echo "$COLUMN"
                fi
              done
            fi
          done
          QUERY_P1="SELECT *"
          echo -e "\nNow, insert the name of the tables you selected to finish creating your query by following this synthax:\nFROM table_1 FULL JOIN table_2 USING (common_col_1) FULL JOIN table_3 USING(common_col_2) FULL JOIN table_4 USING(common_col_3);\n\nNote: common_col_1 is a column existing in the both tables 1 and 2, while common_col_2 is a table existing in both tables 2 and 3,...\n\nThis logic can be extended to as many tables as needed; the part that repeats to add more tables is:\nFULL JOIN table_x USING(common_col_x)\nNow, it's your turn, let's try!" ;
          read QUERY_P2 
          echo -e "\nFinally, insert the desired file name (without its .format suffix):" 
          read FILENAME
          $(psql -X --csv -U postgres -d nvidia -c "$QUERY_P1 $QUERY_P2" > $FILENAME.csv) 
          echo -e "\nData exportation successful! Don't forget to reward my work with a star on my GitHub: Nmension" ;;
    esac
  }

  SUB_TABLE() {
    echo -e "\nList of existing tables:"
    T_LIST=$($PSQL "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';")
    echo "$T_LIST" | while read TABLES
    do
      echo "$TABLES" 
    done
    echo -e "\nHow many tables would you like your data from?"
    read CHOICE3
    case $CHOICE3 in
      1)  echo -e "\nFrom the list above, insert the name of the table you would like your data from:" 
          read CHOICE4
          if [[ ! "${T_LIST[*]}" =~ $CHOICE4  ]] 
          then
            echo -e "\nThe selected table name doesn't exist. Please make sure to insert its name exactly as it is in the list above."
          else
            COL_LIST=$(psql -X -U postgres -d nvidia -c "SELECT column_name FROM information_schema.columns WHERE table_name = '$CHOICE4'; ")
            echo -e "\nList of columns in $CHOICE4:"
            echo "$COL_LIST" | while read COLUMN 
            do
              if [[ ! ( ( "${COLUMN[*]}" =~ "column_name" ) || ( "${COLUMN[*]}" =~ "-------------" ) || ( "${COLUMN[*]}" =~ (row)+ ) ) ]]
              then
                echo "$COLUMN"
              fi
            done
            echo -e "\nFrom the list above, insert the name(s) of the column(s) you want in $CHOICE4 table separated by commas ','\nsuch as: col_name_1, col_name_2, col_name_3 ..."
            read COL_NAM
            echo -e "\nInsert the desired file name (without its .format suffix):"
            read FILENAME
            $(psql -X --csv -U postgres -d nvidia -c "SELECT $COL_NAM FROM $CHOICE4" > $FILENAME.csv)
            echo -e "\nData exportation successful! Don't forget to reward my work with a star on my GitHub: Nmension"
          fi ;;
      2)  echo -e "\nFrom the list above, insert the name of the first table you would like your data from:" 
          read CHOICE4
          if [[ ! "${T_LIST[*]}" =~ $CHOICE4  ]] 
          then
            echo "The first selected table name doesn't exist. Please make sure to insert its name exactly as it is in the list above."
          else
            echo -e "\nName of the second table:"
            read CHOICE5
            if [[ ! "${T_LIST[*]}" =~ $CHOICE5  ]]
            then
              echo "The second selected table name doesn't exist. Please make sure to insert its name exactly as it is in the list above."
            else
              COL_LIST_T1=$(psql -X -U postgres -d nvidia -c "SELECT column_name FROM information_schema.columns WHERE table_name = '$CHOICE4'; ")
              COL_LIST_T2=$(psql -X -U postgres -d nvidia -c "SELECT column_name FROM information_schema.columns WHERE table_name = '$CHOICE5'; ")
              echo -e "\nList of columns in $CHOICE4:"
              echo "$COL_LIST_T1" | while read COLUMN_T1 
              do
                if [[ ! ( ( "${COLUMN_T1[*]}" =~ "column_name" ) || ( "${COLUMN_T1[*]}" =~ "-------------" ) || ( "${COLUMN_T1[*]}" =~ (row)+ ) ) ]]
                then
                echo "$COLUMN_T1"
                fi
              done
              echo -e "\nList of columns in $CHOICE5:"
              echo "$COL_LIST_T2" | while read COLUMN_T2 
              do
                if [[ ! ( ( "${COLUMN_T2[*]}" =~ "column_name" ) || ( "${COLUMN_T2[*]}" =~ "-------------" ) || ( "${COLUMN_T2[*]}" =~ (row)+ ) ) ]]
                then
                echo "$COLUMN_T2"
                fi
              done
              echo -e "\nFrom the lists above, insert the name(s) of the column(s) you want in $CHOICE4 and $CHOICE5 tables separated by commas ','\nsuch as:\ncol_name_1, col_name_2, col_name_3 ..."   
              read COL_NAM
              echo -e "\nInsert the desired file name (without its .format suffix):"
              read FILENAME
              echo "$COL_LIST_T1" | while read COLUMN_T1 
              do
                if [[ "${COL_LIST_T2[*]}" =~ $COLUMN_T1 && ! ( ( "${COLUMN_T1[*]}" =~ "column_name" ) || ( "${COLUMN_T1[*]}" =~ "-------------" ) || ( "${COLUMN_T1[*]}" =~ (row)+ ) ) ]]
                then
                  COMMON_COL=$COLUMN_T1
                  $(psql -X --csv -U postgres -d nvidia -c "SELECT $COL_NAM FROM $CHOICE4 FULL JOIN $CHOICE5 USING($COMMON_COL)" > $FILENAME.csv)
                  echo -e "\nData exportation successful! Don't forget to reward my work with a star on my GitHub: Nmension"
                fi
              done
            fi
          fi ;;
      *)  echo -e "\nFor 3 tables or more, I am going to assist you in creating the required query for the data you want to export."
          echo -e "\nList of existing tables:"
          T_LIST=$($PSQL "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';")
          echo "$T_LIST" | while read TABLES
          do
            echo "$TABLES" 
          done
          until [[ $CHOICE4 =~ "ok" ]]
          do
            echo -e "\nFirst, check the columns in each table you want by inserting its name as in the list above:\nWhen you knows which columns in which tables you want, insert 'ok' instead."
            read CHOICE4 
            if [[ ! "${T_LIST[*]}" =~ $CHOICE4  ]] 
            then
              echo "The selected table name doesn't exist. Please make sure to insert its name exactly as it is in the table list above."
            else
              COL_LIST=$(psql -X -U postgres -d nvidia -c "SELECT column_name FROM information_schema.columns WHERE table_name = '$CHOICE4'; ")
              echo -e "\nList of columns in $CHOICE4:"
              echo "$COL_LIST" | while read COLUMN 
              do
                if [[ ! ( ( "${COLUMN[*]}" =~ "column_name" ) || ( "${COLUMN[*]}" =~ "-------------" ) || ( "${COLUMN[*]}" =~ (row)+ ) ) ]]
                then
                  echo "$COLUMN"
                fi
              done
            fi
          done
          echo -e "\nNow, insert the name of the column(s) you want in your tables separated by commas ',' such as:\ncol_name_1, col_name_2, ..." 
          read COL_NAM 
          QUERY_P1="SELECT $COL_NAM"
          echo -e "\nNow, insert the name of the tables you selected your columns from to finish creating your query by following this synthax:\nFROM table_1 FULL JOIN table_2 USING (common_col_1) FULL JOIN table_3 USING(common_col_2) FULL JOIN table_4 USING(common_col_3);\n\nNote: common_col_1 is a column existing in the both tables 1 and 2, while common_col_2 is a table existing in both tables 2 and 3,...\n\nThis logic can be extended to as many tables as needed; the part that repeats to add more tables is:\nFULL JOIN table_x USING(common_col_x)\nNow, it's your turn, let's try!" ;
          read QUERY_P2 
          echo -e "\nFinally, insert the desired file name (without its .format suffix):" 
          read FILENAME
          $(psql -X --csv -U postgres -d nvidia -c "$QUERY_P1 $QUERY_P2" > $FILENAME.csv) 
          echo -e "\nData exportation successful! Don't forget to reward my work with a star on my GitHub: Nmension" ;;
    esac
  }

  case $CHOICE2 in
    1) TABLES ;;
    2) SUB_TABLE ;;
    *) EXPORT_MENU ;;
  esac
}
MAIN_MENU