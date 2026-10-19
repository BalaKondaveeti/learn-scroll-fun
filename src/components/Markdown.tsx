import ReactMarkdown from 'react-markdown'

export function Markdown({ children }: { children: string }) {
  return (
    <ReactMarkdown
      components={{
        p: ({ children }) => <p className="mb-4 last:mb-0">{children}</p>,
        strong: ({ children }) => <strong className="font-bold text-[var(--ink)]">{children}</strong>,
        em: ({ children }) => <em className="italic">{children}</em>,
        ol: ({ children }) => <ol className="mb-4 list-decimal space-y-1.5 pl-6 last:mb-0">{children}</ol>,
        ul: ({ children }) => <ul className="mb-4 list-disc space-y-1.5 pl-6 last:mb-0">{children}</ul>,
        a: ({ children, href }) => (
          <a href={href} target="_blank" rel="noreferrer" className="underline underline-offset-4">
            {children}
          </a>
        ),
      }}
    >
      {children}
    </ReactMarkdown>
  )
}
