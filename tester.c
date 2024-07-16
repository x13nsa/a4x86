#include <stdio.h>
#include <limits.h>
#include <stdint.h>
#include <assert.h>

extern int is_lower_ (const char);
extern int is_upper_ (const char);

extern int is_digit_ (const char);
extern int is_xdigit_ (const char);

extern int is_alpha_ (const char);
extern int is_alnum_ (const char);
extern int is_space_ (const char);

extern int to_lower_ (const char);
extern int to_upper_ (const char);

static void test_types ()
{
	uint8_t	lower = 0, upper = 0;
	uint8_t	digits = 0, xdigits = 0;
	uint8_t alpha = 0, alnum  = 0, spaces = 0;

	for (int8_t a = 0; a < CHAR_MAX; a++)
	{
		if (is_lower_(a)) lower++;
		if (is_upper_(a)) upper++;
		if (is_space_(a)) spaces++;
		if (is_digit_(a)) digits++;
		if (is_xdigit_(a)) xdigits++;
		if (is_alnum_(a)) alnum++;
		if (is_alpha_(a)) alpha++;

		if (is_lower_(a)) assert(to_upper_(a) == (a - 32));
		else assert(to_upper_(a) == a);

		if (is_upper_(a)) assert(to_lower_(a) == (a + 32));
		else assert(to_lower_(a) == a);
	}

	assert(lower == 26);
	assert(upper == 26);
	assert(spaces == 6);
	assert(digits == 10);
	assert(xdigits == 22);
	assert(alpha == lower + upper);
	assert(alnum == lower + upper + digits);
	puts("types: ok!");
}

extern size_t strlen_ (const char*);

static void test_strlen (void)
{
	assert(strlen_("") == 0);
	assert(strlen_(NULL) == 0);
	assert(strlen_("123") == 3);
	assert(strlen_("hola") == 4);
	assert(strlen_("salut") != 4);
	puts("strlen: ok!");
}

extern int strncmp_ (const char*, const char*, const size_t);

static void test_strncmp (void)
{
	const char *a = "this is a test";

	assert(strncmp_("hola", "hola", 4) == 1);
	assert(strncmp_("will i see you again?", "will i see you again?", 10) == 1);
	assert(strncmp_(a, "this is a Test", 11) == 0);
	assert(strncmp_(a, a, strlen_(a)) == 1);
	assert(strncmp_("abc", "abcde", 5) == 0);
	assert(strncmp_("abcde", "abc", 5) == 0);
	assert(strncmp_("....", "..", 4) == 0);
	puts("strncmp: ok!");
}

int main (void)
{
	test_types();
	test_strlen();
	test_strncmp();
	return 0;
}
