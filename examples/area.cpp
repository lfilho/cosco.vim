#include <iostream>
/* the line above was ignored because of this setting
let g:cosco_ignore_ft_pattern = {
      \ 'cpp': '^#',
}
*/

float triangle_area(float a, float b) { return a * b / 2.0; };

int main(int argc, char *argv[]) {
  auto area = triangle_area(10, 20);
  std::cout << "area " << area << std::endl;
  return 0;
}
