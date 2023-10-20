from unittest import TestCase, main

from whiteboard import solution

class MatchTestCase(TestCase):
    def test_example_one(self):
        self.assertEqual(solution([5,8,6,4]), 9)
    def test_example_two(self):
        self.assertEqual(solution([1,2,4,6]), 11)
    def test_multi(self):
        self.assertEqual(solution([10,20,30,11]),49 )
    def test_all_but_one(self):
        self.assertEqual(solution([0,0,0,0,1]),4)



if __name__ == '__main__':
    main()