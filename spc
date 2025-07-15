#!/usr/bin/env python3
#
# Sekai parking calculator

from argparse import ArgumentParser

def decompose_number(target, numbers, current_combination=[]):
    """Decompose a number to its terms from the list.
    Example input: 11, [3, 2]
    Example output: [3, 3, 3, 2]
    """
    if target == 0:
        return current_combination
    for number in numbers:
        if number <= target:
            result = decompose_number(target - number, numbers, current_combination + [number])
            if result is not None:
                return result

def exclude_every_third(a, b):
    """Exclude every third number from [a-b] range.
    Example: [0, 1, 2, 3] ==> [0, 1, 3]
    """
    list_without_third = []
    count = 0
    for i in range(a, b):
        count += 1
        if count != 3:
            list_without_third.append(i)
        else:
            count = 0
    return list_without_third

def count_third(a, b):
    """Count the third elements in [a-b] range."""
    count_third = 0
    count = 0
    for i in range(a, b):
        count += 1
        if count == 3:
            count_third += 1
            count = 0
    return count_third

def points_to_shows(points_list):
    """Display the conditions necessary to obtain given points.
    Output: show index number, team order (all 4* 0MR or all 1* 5MR),
            score order, expected points
    Example: 1) 4* [1000000-1019999] (225)
    """
    i = 0
    for points in points_list:
        i += 1
        if points > 112:
            team_order = "4* "
            extra_points = 150 + count_third(150, points)
        else:
            team_order = "1* "
            extra_points = 102
        multiplier = points - extra_points
        score_order = "[" + str(20000*multiplier) + "-" + str(20000*multiplier + 19999) + "]"
        print(str(i) + ") " + team_order + score_order + " (" + str(points) + ")")

def main():
    parser = ArgumentParser(description="sekai parking calculator",
                            epilog="use non event cards, all 1* 5MR (2% EB)"
                                    + " and all 4* 0MR (50% EB)"
                                    + ", play ebi on easy with 0x")

    parser.add_argument("-p", "--target", type=int,
                        help="specify target points", required=True)
    args = parser.parse_args()

    target_number = args.target
    # EP increase with score on 50% EB: 150, 151, ~~THIRD~~, 153...
    number_list = (list(reversed(exclude_every_third(150, 226)))
                   + list(reversed(range(102, 113))))
    points_list = decompose_number(target_number, number_list)
    if points_list is not None:
        print("### " + str(target_number) + "\n")
        print("```")
        points_to_shows(points_list)
        print("```" + "\n")
    else:
        raise ValueError()

if __name__ == "__main__":
    main()
