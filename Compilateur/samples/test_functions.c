/* TEST 1 :
int f(int a) {
    return a + 2;
}

void main() {
    int a = f(2);
} */

/* TEST 2 : */
int fact(int a) {
    int res = 1 ;
    if (a) {
        res = fact(a - 1) * a;
    }
    return res ;
}

int main() {
    return fact(3) ;
}