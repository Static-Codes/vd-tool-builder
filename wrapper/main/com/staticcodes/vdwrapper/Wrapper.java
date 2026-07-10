package com.staticcodes.vdwrapper;

import com.android.ide.common.vectordrawable.VdCommandLineTool;

public class Wrapper 
{
    public static void main(String[] args) 
    {
        if (args.length != 5) {
            System.out.println("Invalid usage.");
            System.out.println("vdwrapper -c -in input.svg -out outputDir");
            System.exit(1);
        }

        VdCommandLineTool.main(args);
    }
}