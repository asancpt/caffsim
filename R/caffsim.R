#' Compare variable names between CRF and data dictionary
#'
#' \code{caffsim} uses CRF-derived csv file and a data dictionary excel to compare
#' variable names of each file
#'
#' @param CRFcsv A filename of CRF csv file, exported from PDFCRF
#' @param Dictionaryxlsx A filename of data dictionary xlsx file
#' @importFrom tidyr separate
#' @import dplyr
#' @import xlsx
#' @export
#' @return List of output data of comparison of variables between a CRF-derived csv file and a data dictionary
#' @examples
#'\dontrun{
#'caffsim(CRFcsv = "foo.csv", Dictionaryxlsx = "foo.xlsx")
#'}

caffsim <- function(CRFcsv, Dictionaryxlsx){
    # Blank variables
    Output <- list()
    Domain.data <- data.frame()

    ## Data dictionary
    Domain.list <- read.xlsx(Dictionaryxlsx, sheetName = "List", startRow=2,
                             stringsAsFactors = FALSE, encoding="UTF-8", header = FALSE) %>%
        rename(Num = X1, Domain2 = X2, KoreanDomain = X3) %>%
        mutate(Domain2 = trimws(gsub("\\(.*$", "", Domain2))) %>%
        filter(!is.na(Domain2)) %>%
        mutate(Domain = paste(Num, Domain2, sep = "."))

    for (i in 1:dim(Domain.list)[1]){
        DID = Domain.list$Domain[i]
        print(paste0("Reading data dictionary xlsx file - Tab ", DID))
        Raw <- read.xlsx(Dictionaryxlsx, sheetName = DID, startRow = 1, stringsAsFactors = FALSE, encoding="UTF-8", colIndex = 1:6)
        Raw$VAR <- trimws(Raw$VAR)
        Domain.data <- rbind(Domain.data, data.frame(DOMAIN = DID, Raw))
    }

    # Exception
    EXCEPT <- read.xlsx(Dictionaryxlsx, sheetName = "EXCEPT", startRow = 1,
                        stringsAsFactors = FALSE, encoding="UTF-8", colIndex = 1:5) %>%
        select(VAR = 1, Prev1 = 2, Prev2 = 3, Focus = 4, VARLABEL = 5) %>%
        filter(Focus == "V")

    ## PDFCSV
    transposeCRFcsv <-  t(read.csv(CRFcsv, stringsAsFactors = FALSE, header = FALSE))[,1]
    PDF.variable.raw <- data.frame(row.names = NULL, PVAR = transposeCRFcsv)

    # Subset
    Variable <- c(Domain.data %>% select(VAR) %>% filter(!is.na(VAR)) %>% t() %>% as.vector(),
                  EXCEPT %>% select(VAR) %>% filter(!is.na(VAR)) %>% t() %>% as.vector())

    PDF.variable <- suppressWarnings(PDF.variable.raw %>% filter(PVAR != "") %>%
        tidyr::separate(col = PVAR, into = c("PVAR", "At"), sep = "\\."))

    Suffix = read.xlsx(Dictionaryxlsx, sheetName = "SUFFIX", startRow=1,
                       stringsAsFactors = FALSE, encoding="UTF-8", colIndex = 1:6) %>%
        select(Section = 1, Prev1 = 2, Prev2 = 3, Focus = 4, Category = 5, Suffix = 6) %>%
        filter(Focus == "V")
    Suffix.df1 = unique(na.omit(PDF.variable$At))
    Suffix.df2 = unique(na.omit(Suffix$Suffix))

    Output$CRF.only.Suffix <- setdiff(Suffix.df1, Suffix.df2)
    Output$Dictionary.only.Suffix <- setdiff(Suffix.df2, Suffix.df1)
    Output$Suffix.Summary <- paste("CRF.only =", length(setdiff(Suffix.df1,Suffix.df2)),
                                     "/ Dictionary only = ", length(setdiff(Suffix.df2,Suffix.df1)),
                                     "/ Intersect = ", length(intersect(Suffix.df1,Suffix.df2)),
                                     "/ Union = ", length(union(Suffix.df1,Suffix.df2)))

    df1 = unique(na.omit(PDF.variable$PVAR))
    df2 = unique(Variable)

    Output$CRF.only.Variable <- setdiff(df1, df2)
    Output$Dictionary.only.Variable <- setdiff(df2, df1)
    Output$Variable.Summary <- paste("CRF.only =", length(setdiff(df1,df2)),
                    "/ Dictionary only = ", length(setdiff(df2,df1)),
                    "/ Intersect = ", length(intersect(df1,df2)),
                    "/ Union = ", length(union(df1,df2)))
    return(Output)
}
