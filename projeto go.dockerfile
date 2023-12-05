package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"sort"
	"strconv"
)

// Entidade representa uma linha de dados no arquivo CSV.
type Entidade struct {
	Nome      string
	Idade     int
	Pontuacao int
}

type PorNome []Entidade

func (a PorNome) Len() int           { return len(a) }
func (a PorNome) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a PorNome) Less(i, j int) bool { return a[i].Nome < a[j].Nome }


type PorIdade []Entidade

func (a PorIdade) Len() int           { return len(a) }
func (a PorIdade) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a PorIdade) Less(i, j int) bool { return a[i].Idade < a[j].Idade }


func LerArquivo(nomeArquivo string) ([]Entidade, error) {
	arquivo, err := os.Open(nomeArquivo)
	if err != nil {
		return nil, err
	}
	defer arquivo.Close()

	reader := csv.NewReader(arquivo)
	linhas, err := reader.ReadAll()
	if err != nil {
		return nil, err
	}

	var entidades []Entidade
	for _, linha := range linhas {
		idade, err := strconv.Atoi(linha[1])
		if err != nil {
			return nil, err
		}
		pontuacao, err := strconv.Atoi(linha[2])
		if err != nil {
			return nil, err
		}
		entidade := Entidade{
			Nome:      linha[0],
			Idade:     idade,
			Pontuacao: pontuacao,
		}
		entidades = append(entidades, entidade)
	}

	return entidades, nil
}


func EscreverArquivo(nomeArquivo string, entidades []Entidade) error {
	arquivo, err := os.Create(nomeArquivo)
	if err != nil {
		return err
	}
	defer arquivo.Close()

	writer := csv.NewWriter(arquivo)
	defer writer.Flush()

	for _, entidade := range entidades {
		err := writer.Write([]string{entidade.Nome, strconv.Itoa(entidade.Idade), strconv.Itoa(entidade.Pontuacao)})
		if err != nil {
			return err
		}
	}

	return nil
}

func main() {
	arquivoEntrada := "dados.csv"
	arquivoSaidaPorNome := "ordenado_por_nome.csv"
	arquivoSaidaPorIdade := "ordenado_por_idade.csv"

	
	entidades, err := LerArquivo(arquivoEntrada)
	if err != nil {
		fmt.Println("Erro ao ler o arquivo de entrada:", err)
		return
	}

	
	sort.Sort(PorNome(entidades))
	err = EscreverArquivo(arquivoSaidaPorNome, entidades)
	if err != nil {
		fmt.Println("Erro ao escrever o arquivo ordenado por nome:", err)
		return
	}

	
	sort.Sort(PorIdade(entidades))
	err = EscreverArquivo(arquivoSaidaPorIdade, entidades)
	if err != nil {
		fmt.Println("Erro ao escrever o arquivo ordenado por idade:", err)
		return
	}

	fmt.Println("Processamento concluído com sucesso.")
}

