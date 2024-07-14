#include <stdio.h>
#include <limits.h>
#include <stdint.h>
#include <assert.h>

extern int is_lower (const char);
extern int is_upper (const char);

extern int is_digit (const char);
extern int is_xdigit (const char);

extern int is_alpha (const char);
extern int is_alnum (const char);
extern int is_space (const char);

extern int to_lower (const char);
extern int to_upper (const char);

static void test_types ()
{
	uint8_t	lower = 0, upper = 0;
	uint8_t	digits = 0, xdigits = 0;
	uint8_t alpha = 0, alnum  = 0, spaces = 0;

	for (int8_t a = 0; a < CHAR_MAX; a++)
	{
		if (is_lower(a)) lower++;
		if (is_upper(a)) upper++;
		if (is_space(a)) spaces++;
		if (is_digit(a)) digits++;
		if (is_xdigit(a)) xdigits++;
		if (is_alnum(a)) alnum++;
		if (is_alpha(a)) alpha++;

		if (is_lower(a)) assert(to_upper(a) == (a + 32));
		else assert(to_upper(a) == a);

		if (is_upper(a)) assert(to_lower(a) == (a - 32));
		else assert(to_lower(a) == a);
	}

	assert(lower == 26);
	assert(upper == 26);
	assert(spaces == 6);
	assert(digits == 10);
	assert(xdigits == 16);
	assert(alpha == lower + upper);
	assert(alnum == lower + upper + digits);
	puts("types: ok!");
}

int main (void)
{
	test_types();
	return 0;
}
