"""
0
"""

import System
import System.Collections.Generic
import System.Text
import System.Threading
import System.Threading.Tasks

class TestCase:
    static int test = 0
    static int count = 0

    [async] public static def Run() as Task:
        try:
            test++
            Qux(async({ return 1 }))
            await Task.Delay(50)
        ensure:
            Driver.Result = test - count
            Driver.CompleteSignal.Set()

    [async] static def Qux[of T](x as Func[of Task[of T]]):
        var y = await(x())
        if y cast int == 1:
            count++

class Driver:
    static public CompleteSignal = AutoResetEvent(false)
    public static int Result = -1

public static def Main():
    TestCase.Run()
    Driver.CompleteSignal.WaitOne()
    Console.WriteLine(Driver.Result)
