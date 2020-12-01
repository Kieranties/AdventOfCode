using System;
using System.Collections.Generic;
using System.Linq;

namespace AdventOfCode2020
{
    public class ReportRepair
    {
        private readonly int[] _input;

        public ReportRepair(IEnumerable<int> input)
        {
            _input = input.ToArray(); // no value in keep non-distinct values
        }

        public int Calculate(int sum, int operands = 2)
        {
            var result = Loop(0, operands, sum, Enumerable.Empty<int>());
            if (result.HasValue)
                return result.Value;

            throw new InvalidOperationException("Unable to find a result.");
        }

        private int? Loop(int start, int innerLoops, int sum, IEnumerable<int> values)
        {
            if(innerLoops == 0)
            {
                var success = values.Sum() == sum;
                if(success)
                    return values.Aggregate((left, right) => left * right);

                return null;
            }

            for (var count = start; count < _input.Length; count++)
            {
                var next = values.Append(_input[count]);
                var result = Loop(start + 1, innerLoops - 1, sum, next);
                if (result.HasValue)
                    return result.Value;
            }

            return null;
        }
    }
}
