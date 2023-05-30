/* TEST 1 :basique */
int f(int a) {
    return a + 2;
}

void main() {
    int a = f(2);
    printf(a) ;
} 

/* TEST 2 : appels récursifs 
int fact(int a) {
    int res = 1 ;
    if (a) {
        res = fact(a - 1) . a;
    }
    return res ;
} 

int main() {
    int a = fact(4) ;
    printf(a) ;
    return a ;
} */

/* TEST 3 : pas de paramètres 
void f() {
    int a = 1 ;
    printf(a) ;
}

void main() {
    f();
} */


/* TEST 4 : plusieurs paramètres 
int f(int a, int b) {
    return a + b;
}

void main() {
    int a = f(2,1);
}
*/
