import ReactMarkdown from 'react-markdown'

export function Markdown({ children }: { children: string }) {
  return (
    <ReactMarkdown
      components={{
        p: ({ children }) => <p className="mb-[0.8em] last:mb-0">{children}</p>,
        strong: ({ children }) => <strong className="font-bold">{children}</strong>,
        em: ({ children }) => <em className="italic">{children}</em>,
        ol: ({ children }) => <ol className="mb-[0.8em] list-decimal space-y-1 pl-6 last:mb-0">{children}</ol>,
        ul: ({ children }) => <ul className="mb-[0.8em] list-disc space-y-1 pl-6 last:mb-0">{children}</ul>,
        a: ({ children, href }) => <a href={href} target="_blank" rel="noreferrer" className="underline underline-offset-4">{children}</a>,
      }}
    >
      {children}
    </ReactMarkdown>
  )
}
