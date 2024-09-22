package main

import (
	"context"
	"fmt"
	"github.com/jackc/pgx/v5"
	"github.com/xuri/excelize/v2"
	"log"
	"strconv"
)

const (
	dbURL = "postgresql://user111:password111@localhost:5432/DevMethology-lab1"
)

func main() {
	ctx := context.Background()
	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Unable to connection to database: %v\n", err)
	}
	defer conn.Close(ctx)
	log.Println("Connected!")

	file, err := excelize.OpenFile("data.xlsx")
	if err != nil {
		log.Fatalf("Could not opened file: %v", err)
	}
	defer func() {
		// Close the spreadsheet.
		if err := file.Close(); err != nil {
			fmt.Println(err)
		}
	}()

	// Uncomment funcs below to fill required tables:

	//importTableIdName(conn, file, "color", "colors")

	//importTableIdName(conn, file, "material", "souvenirmaterials")

	//importTableIdName(conn, file, "applicMetod", "applicationmetods")

	//importSouvenirs(conn, file)
}

func importTableIdName(conn *pgx.Conn, file *excelize.File, xlsxcol, psqltable string) {
	cols, err := file.GetCols("Sheet1")
	if err != nil {
		log.Fatal(err)
	}
	query := make([][]any, 0)

	mp := make(map[string]struct{})
	uuid := 1
	for _, col := range cols {
		if col[0] != xlsxcol {
			continue
		}
		for i := range col {
			if i == 0 {
				continue
			}
			c := col[i]
			if _, ok := mp[c]; !ok {
				mp[c] = struct{}{}
				query = append(query, []any{uuid, c})
				uuid++
			}
		}
	}

	res, err := conn.CopyFrom(
		context.Background(),
		pgx.Identifier{psqltable},
		[]string{"id", "name"},
		pgx.CopyFromRows(query),
	)
	if err != nil {
		log.Fatalf("Unable to copy data to database: %v\n", err)
	}

	log.Printf("==>Table %s: import rows affected:%v\n", psqltable, res)
}

func importSouvenirs(conn *pgx.Conn, file *excelize.File) {
	rows, err := file.GetRows("Sheet1")
	if err != nil {
		log.Fatal(err)
	}
	query := make([][]any, 0)

	for i := range rows {
		if i == 0 {
			continue
		}
		row := rows[i]
		if len(row) != 19 {
			log.Fatalf("invalid row: %v", row)
		}
		r0, err := strconv.Atoi(row[0])
		if err != nil {
			log.Fatalf("invalid id type: %v", err)
		}
		if len(row[9]) == 0 {
			row[9] = "7"
		}
		r9, err := strconv.Atoi(row[9])
		if err != nil {
			log.Fatalf("invalid rating type: %v", err)
		}
		if len(row[8]) == 0 {
			row[8] = "7777"
		}
		r8, err := strconv.Atoi(row[8])
		if err != nil {
			log.Fatalf("invalid idcategory type: %v", err)
		}
		if len(row[11]) == 0 {
			row[11] = "10.0"
		}
		r11, err := strconv.ParseFloat(row[11], 64)
		if err != nil {
			log.Fatalf("invalid weight type: %v", err)
		}
		if len(row[10]) == 0 {
			row[10] = "10.0"
		}
		r10, err := strconv.ParseFloat(row[10], 64)
		if err != nil {
			log.Fatalf("invalid dealerprice type: %v", err)
		}
		if len(row[6]) == 0 {
			row[6] = "10.0"
		}
		r6, err := strconv.ParseFloat(row[6], 64)
		if err != nil {
			log.Fatalf("invalid price type: %v", err)
		}
		var idcolor int
		err = conn.QueryRow(context.Background(), "select id from colors where name=$1", row[12]).Scan(&idcolor)
		if err != nil {
			log.Fatalf("Failed to execute QUERY %v, err: %v", "table colors", err)
		}
		var idmaterial int
		err = conn.QueryRow(context.Background(), "select id from souvenirmaterials where name=$1", row[13]).Scan(&idmaterial)
		if err != nil {
			log.Fatalf("Failed to execute QUERY %v, err: %v", "table souvenirmaterials", err)
		}
		var idapplicmetod int
		err = conn.QueryRow(context.Background(), "select id from applicationmetods where name=$1", row[17]).Scan(&idapplicmetod)
		if err != nil {
			log.Fatalf("Failed to execute QUERY %v, err: %v", "table applicationmetods", err)
		}
		currQuery := []any{r0, row[1], row[3], row[4], row[7], r9, r8, idcolor, row[14], idmaterial, r11, "228", "15", idapplicmetod, row[18], r10, r6, "comm"}
		query = append(query, currQuery)
	}

	res, err := conn.CopyFrom(
		context.Background(),
		pgx.Identifier{"souvenirs"},
		[]string{"id", "url", "shortname", "name", "description", "rating", "idcategory", "idcolor", "size", "idmaterial", "weight", "qtypics", "picssize", "idapplicmetod", "allcategories", "dealerprice", "price", "comments"},
		pgx.CopyFromRows(query),
	)
	if err != nil {
		log.Fatalf("Unable to copy data to database: %v\n", err)
	}

	log.Printf("==>Table souvenirs: import rows affected:%v\n", res)
}
