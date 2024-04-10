#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    pid_t pid;
    pid = fork();

    if (pid < 0) {
        fprintf(stderr, "Fork failed\n");
        return 1;
    } else if (pid == 0) {
        FILE *f1 = fopen("f1", "r");
        FILE *f2 = fopen("f2", "w");

        char buffer[1024];
        size_t bytes_read;

        while ((bytes_read = fread(buffer, 1, sizeof(buffer), f1)) > 0) {
            fwrite(buffer, 1, bytes_read, f2);
        }

        fclose(f1);
        fclose(f2);
    } else {
        FILE *first = fopen("first", "w");
        fprintf(first, "this is the content off the file");
        fclose(first);
    }

    return 0;
}
