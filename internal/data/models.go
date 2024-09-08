package data

import (
	"database/sql"
	"errors"
)

var (
	ErrRecordNotFound = errors.New("record not found")
	ErrEditConflict   = errors.New("edit conflict")
)

type MovieModelInterface interface {
	Insert(movie *Movie) error
	Get(id int64) (*Movie, error)
	Update(movie *Movie) error
	Delete(id int64) error
}

type Models struct {
	Movies MovieModelInterface
}

func InitModels(db *sql.DB) Models {
	return Models{
		Movies: MovieModel{DB: db},
	}
}

func InitMockModels() Models {
	return Models{
		Movies: MockMovieModel{},
	}
}
