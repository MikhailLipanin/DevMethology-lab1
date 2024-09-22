package main

import (
	"context"
	"encoding/csv"
	"github.com/jackc/pgx/v5"
	"io"
	"log"
	"os"
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

	rows := parseCSV()
	log.Println("Parsing CSV completed!")

	res, err := conn.CopyFrom(
		context.Background(),
		pgx.Identifier{"souvenirscategories"},
		[]string{"id", "idparent", "name"},
		pgx.CopyFromRows(rows),
	)
	if err != nil {
		log.Fatalf("Unable to copy data to database: %v\n", err)
	}
	log.Println("==> import rows affected:", res)
}

func parseCSV() [][]any {
	file, err := os.Open("categories.txt")
	if err != nil {
		log.Fatalf("Could not opened file: %v", err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	reader.FieldsPerRecord = 3

	records := make([][]any, 0)
	firstLine := true
	for {
		record, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatalf("Parsing CSV file failed: %v\n", err)
		}
		if len(record[0]) == 0 || len(record[1]) == 0 || len(record[2]) == 0 {
			log.Printf("broken record: %v\n", record)
			continue
		}
		v1, err := strconv.Atoi(record[0])
		if err != nil {
			if !firstLine {
				log.Fatalf("invalid record: %v\n", record)
			}
			continue
		}
		v2, err := strconv.Atoi(record[1])
		if err != nil {
			if !firstLine {
				log.Fatalf("invalid record: %v\n", record)
			}
			continue
		}
		firstLine = false
		curr := make([]any, 0, 3)
		curr = append(curr, any(v1), any(v2), any(record[2]))
		records = append(records, curr)
	}
	return records
}
