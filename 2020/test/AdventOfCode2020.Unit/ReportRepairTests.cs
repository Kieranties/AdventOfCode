using FluentAssertions;
using System.IO;
using System.Linq;
using Xunit;
using Xunit.Abstractions;

namespace AdventOfCode2020.Unit
{
    public class ReportRepairTests
    {
        private readonly ITestOutputHelper _output;

        public ReportRepairTests(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public void Example_Should_Succeed()
        {
            var input = new[] { 1721, 979, 366, 299, 675, 1456 };
            var sut = new ReportRepair(input);
            var result = sut.Calculate(2020);

            result.Should().Be(514579);
        }

        [Fact]
        public async void Example_Part1_Succeed()
        {
            var input = (await File.ReadAllLinesAsync("./inputs/day1.txt"))
                .Select(x => int.Parse(x));
            var sut = new ReportRepair(input);
            var result = sut.Calculate(2020);

            _output.WriteLine($"FOUND: {result}"); // 468051
            result.Should().Be(468051);
        }

        [Fact]
        public async void Example_Part2_Succeed()
        {
            var input = (await File.ReadAllLinesAsync("./inputs/day1.txt"))
                .Select(x => int.Parse(x));
            var sut = new ReportRepair(input);
            var result = sut.Calculate(2020, 3);

            _output.WriteLine($"FOUND: {result}"); // 272611658
            result.Should().Be(272611658);
        }
    }
}
