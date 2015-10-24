public protocol LatexStringConvertable { // This is a math library, after all. Need to be able to easily output to LaTeX. :D
    var latexDescription: String { get }
}