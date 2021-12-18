#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <windows.h>
#include <locale.h>
#include <conio.h>
#define false 0
#define true 1
#define TAMANHO 9





short VerificarLinha(int sudoku[TAMANHO][TAMANHO]);
short VerificaColuna(int sudoku[TAMANHO][TAMANHO]);
short verificarSubmatriz(int submatriz[3][3]);
short verificarSubmatrizes(int matriz[TAMANHO][TAMANHO]);
void inicializarSudoku(int sudoku[TAMANHO][TAMANHO]);
void constutorDeTabela(int sudoku[TAMANHO][TAMANHO]);
void preecherVetor(int vetor[]);
void embaralhar(int vetor[], int embaralhado[]);
void constutorDeTabela(int sudoku[TAMANHO][TAMANHO]);
void inserir_no_sudoku(int sudoku[TAMANHO][TAMANHO]);
void inserirNaMatriz(int sudoku[TAMANHO][TAMANHO], int lin, int col, int val);
void printarMatriz(int sudoku[TAMANHO][TAMANHO]);

void mostraTabuleiro();
void desenhaBaseMatriz();
void desenhaTopoMatriz();
void desenhaMeioMatriz();
void guiaHorizontal();
void guiaVertical();

void menu();

void solicitarJogada();
void caixaDePergunta(int tamanhoPergunta, int tamanhoResposta, char pergunta[], int linha);

void insereValor(int linha, int coluna, char valor, short entradaDoUsuario)
{
    linha = linha == 1 ? 3
            : 3 + (linha - 1) * 2;
    coluna = coluna == 1 ? 5
             : 5 + (coluna - 1) * 3;

    gotoxy(coluna, linha);


    if(entradaDoUsuario == 1)
        SetConsoleTextAttribute( GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_BLUE);
    printf("%c", valor);

    // código abaixo resetar o foreground para branco
    WORD white = 0x0F;
    SetConsoleTextAttribute( GetStdHandle(STD_OUTPUT_HANDLE), white);
}

void gotoxy(int x, int y)
{
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE),(COORD)
    {
        x-1,y-1
    });
}

int main(void)
{
    menu();
}

void mostraTabuleiro()
{
    guiaHorizontal();
    desenhaTopoMatriz();
    desenhaMeioMatriz();
    desenhaBaseMatriz();
    guiaVertical();

    printf("\n");
}

void desenhaTopoMatriz()
{
    printf("  %c", 201); // ╔

    for(int i = 0; i < 17; i++)
    {
        if(i % 2 == 0)
            printf("%c%c", 205, 205); // ═
        else
            printf("%c", 203); // ╦
    }

    printf("%c", 187); // ╗
}

void desenhaBaseMatriz()
{

    printf("\n");

    printf("  %c", 200); // ╚

    for(int i = 0; i < 17; i++)
    {
        if(i % 2 == 0)
            printf("%c%c", 205, 205); // ═
        else
            printf("%c", 202); // ╩
    }

    printf("%c", 188); // ╝
}

void desenhaMeioMatriz()
{
    for(int numLinhas = 0; numLinhas < 8; numLinhas++)
    {
        printf("\n  ");
        for(int i = 0; i < 19; i++)
        {
            if(i % 2 == 0)
                printf("%c", 186); // ║
            else
                printf("  ");
        }

        printf("\n  ");
        printf("%c", 204); // ╠
        for(int i = 0; i < 17; i++)
        {
            if(i % 2 == 0)
                printf("%c%c", 205, 205); // ═
            else
                printf("%c", 206); // ╬

        }
        printf("%c", 185); // ╣
    }

    printf("\n  ");
    for(int i = 0; i < 19; i++)
    {
        if(i % 2 == 0)
            printf("%c", 186); // ║
        else
            printf("  ");
    }
}

void guiaHorizontal()
{
    for(int i = 0; i < 9; i++)
    {
        gotoxy(3 * i+3, 1);
        printf("  %d", i);
    }

    printf("\n");
}

void guiaVertical()
{
    for(int i = 0; i < 9; i++)
    {
        gotoxy(2, (3 * i+4) - (i+1));
        printf("%d", i);
    }
}

void solicitarJogada()
{
    char col, lin, val;

    printf("\n");
    caixaDePergunta(30, 2, "Insira coluna", 22);
    scanf("%c", &col);

    printf("\n");
    caixaDePergunta(30, 2, "Insira linha", 27);
    scanf("%c", &lin);

}

void caixaDePergunta(int tamanhoPergunta, int tamanhoResposta, char pergunta[30], int linha)
{
    // TOPO
    printf("%c", 201); // ╔
    for(int i = 0; i < tamanhoPergunta; i++)
        printf("%c", 205); // ═
    printf("%c", 203); // ╦
    for(int i = 0; i < tamanhoResposta; i++)
        printf("%c", 205); // ═
    printf("%c", 187); // ╗

    //MEIO
    printf("\n");
    printf("%c", 186); // ║
    for(int i = 0; i < tamanhoPergunta; i++)
        printf(" ");
    printf("%c", 186); // ║
    for(int i = 0; i < tamanhoResposta; i++)
        printf(" ");
    printf("%c", 186); // ║

    //BASE
    printf("\n");
    printf("%c", 200); // ╚
    for(int i = 0; i < tamanhoPergunta; i++)
        printf("%c", 205); // ═
    printf("%c", 202); // ╩
    for(int i = 0; i < tamanhoResposta; i++)
        printf("%c", 205); // ═
    printf("%c", 188); // ╝

    gotoxy(2, linha);
    printf("%s", pergunta);
}

void inserirNaMatriz(int sudoku[TAMANHO][TAMANHO], int lin, int col, int val)
{
    if (sudoku[lin][col] == 0)
    {
        sudoku[lin][col] = val;
    }
}

void inserir_no_sudoku(int sudoku[TAMANHO][TAMANHO])
{
    int L, C, quant = 50;
    do
    {
        printf("Linha X Coluna: ");
        scanf("%d %d", &L, &C);
        if (sudoku[L][C] == 0)
        {
            printf("Digite o número sudoku[%d][%d]: ",L,C);
            scanf("%d", &sudoku[L][C]);
            ++quant;
        }
        else
        {
            printf("Posição preenchida!!!\n");

        }
        system("cls");

        for (int i = 0; i < 9; i++)
        {
            for (int j = 0; j < 9; j++)
            {
                printf("%d ", sudoku[i][j]);
            }
            printf("\n");
        }

    }
    while(quant < 81);
}

short VerificarLinha(int sudoku[TAMANHO][TAMANHO])
{
    for(int L = 0; L < 9; L++)
        for (short k = 0; k < 9; k++)
            for (short x = k + 1; x < 9; x++)
                if (sudoku[L][k] == sudoku[L][x] && x != k)
                {
                    return 0;
                }
    return 1;
}

short VerificaColuna(int sudoku[TAMANHO][TAMANHO])
{
    for(int c = 0; c < 9; c++)
    {
        for (int L = 0; L < 9; L++)
        {
            for (int f = L + 1; f < 9; f++)
                if (sudoku[L][c] == sudoku[f][c])
                    return 0;
        }
    }
    return 1;
}

short verificarSubmatriz(int submatriz[3][3])
{
    int i, j, num, valido = 0;
    for(num = 1; num <=9; num++)
    {
        for(i = 0; i < 3; i++)
            for(j = 0; j < 3; j++)
                if(submatriz[i][j] == num)
                {
                    valido++;
                }
        if(valido > 1)
        {
            return 0;
        }
        valido = 0;
    }
    return 1;

}

short verificarSubmatrizes(int matriz[TAMANHO][TAMANHO])
{

    int i,j,y,x,subM[3][3];

    for(i = 0; i < 9; i+=3)
        for(j = 0; j < 9; j+=3)
        {
            for(y = 0; y < 3; y++)
                for(x = 0; x < 3; x++)
                    subM[y][x] = matriz[y+i][x+j];
            if(!verificarSubmatriz(subM))
                return 0;

        }
    return 1;
}

void direcionador(int *number)
{
    if (*number > 9)
    {
        *number %= 9;
    }
}


void preecherVetor(int vetor[])
{
    int number = 0;
    srand(time(NULL));

    number = 1 + rand() % 9;

    vetor[0] = number;
    for(int i = 1; i < 9; i++)
    {
        vetor[i] = vetor[i - 1] + 3;

        direcionador(&vetor[i]);

        if(i != 9 && (i+1) % 3 == 0)
        {
            ++i;
            vetor[i] = number += 1;
            direcionador(&vetor[i]);
        }
    }


}

void inicializarSudoku(int sudoku[TAMANHO][TAMANHO])
{
    for (int i = 0; i < 9; i++)
    {
        for (int j = 0; j < 9; j++)
        {
            sudoku[i][j] = 0;
        }
    }
}

void constutorDeTabela(int sudoku[TAMANHO][TAMANHO])
{
    int primeiraLinha[TAMANHO];
    // preenche o vetor com uma sequ�ncia de 1 a 9. Sendo que os vetor n�o possuir
    // valores repetidos.
    preecherVetor(primeiraLinha);

    srand(time(NULL));

    int quant = 0, L = 0, C = 0;

    do {
        L = rand() % 9;
        C = rand() % 9;

        if(sudoku[L][C] == 0) {
            sudoku[L][C] = primeiraLinha[C];
            if(L > 0)
                sudoku[L][C] += L;


            ++quant;

            direcionador(&sudoku[L][C]);
        }
    }while(quant < 50);

}

void printarMatriz(int sudoku[TAMANHO][TAMANHO])
{
    for(int i = 0; i < 9; i++)
        for(int j = 0; j < 9; j++)
        {
            int valor = sudoku[i][j];
            char valorParaTabela = ' ';

            if(valor != 0)
                valorParaTabela = valor + '0'; //cast valor para char

            insereValor(i + 1, j + 1, valorParaTabela, 0);
        }
}

void menu()
{
    int sudoku[TAMANHO][TAMANHO];
    int col, lin, val;
    int escolha, escolha2 = 0;
    inicializarSudoku(sudoku);
    constutorDeTabela(sudoku);

    gotoxy(25, 3);
    printf("SUDOKU");
    gotoxy(5, 5);
    printf("\n");
    caixaDePergunta(2, 50, "1", 7);
    gotoxy(5, 7);
    printf("Iniciar novo jogo");
    printf("\n\n");
    caixaDePergunta(2, 50, "2", 10);
    gotoxy(5, 10);
    printf("Como jogar\n");
    printf("\n\n");
    caixaDePergunta(2, 50, "3", 14);
    gotoxy(5, 14);
    printf("Sair \n");
    printf("\n\n");
    gotoxy(17, 20);
    printf("Digite sua escolha:\n");

    scanf("%d", &escolha);

    system("cls");


    switch(escolha)
    {
    case 1:
        while(true)
        {
            mostraTabuleiro();
            printarMatriz(sudoku);
            gotoxy(20, 20);

            printf("\n");
            caixaDePergunta(30, 2, "Insira coluna", 22);
            gotoxy(33, 22);
            scanf("%d", &col);
            getchar();

            printf("\n");
            caixaDePergunta(30, 2, "Insira linha", 25);
            gotoxy(33, 25);
            scanf("%d", &lin);
            getchar();

            printf("\n");
            caixaDePergunta(30, 2, "Insira valor", 28);
            gotoxy(33, 28);
            scanf("%d", &val);
            getchar();

            inserirNaMatriz(sudoku, lin, col, val);
            system("cls");
        }
        break;
    case 2:

        system("cls");
        gotoxy(35, 3);
        printf("Passos para jogar:");
        gotoxy(5, 5);
        printf("\n");
        caixaDePergunta(2, 100, "1o", 7);
        gotoxy(5, 7);
        printf("Cada linha deve conter os numeros de 1 a 9, sem repeticoes");
        printf("\n\n");
        caixaDePergunta(2, 100, "2o", 10);
        gotoxy(5, 10);
        printf(" Os numeros de 1 a 9 apenas podem estar presentes uma vez por coluna \n");
        printf("\n\n");
        caixaDePergunta(2, 100, "3o", 14);
        gotoxy(5, 14);
        printf("Cada digito apenas pode estar presente uma vez por grupo \n");
        printf("\n\n");
        caixaDePergunta(2, 100, "4o", 18);
        gotoxy(5, 18);
        printf("O valor da soma de cada linha, coluna e grupo deve ser de 45 \n");
        gotoxy(35, 20);
        printf("Pronto, agora voce pode jogar!\n");
        gotoxy(35, 20);
        printf("Para retornar ao menu inicial, digite 1\n");
        scanf("%d", &escolha2);
        if(escolha2=1)
        {
            system("cls");
            menu();
        }


        break;



    }
    gotoxy(80, 20);

}
