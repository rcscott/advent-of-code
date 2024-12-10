diskmap = File.open("input.txt").read.chomp.chars.map(&:to_i)

puts "Part 1:"
class DiskCompacter
  attr_reader :checksum

  def initialize(diskmap)
    @diskmap = diskmap
    @diskmap_size = diskmap.size
    @new_diskmap = []
    @checksum = 0

    @current_block_loc = 0
    @head = diskmap.each_with_index
    @head_file_id = 0

    @tail = diskmap.reverse.each_with_index
    @tail_file_id = @diskmap_size / 2
  end

  def compact!
    head_block_count, head_loc = @head.next
    tail_block_count, tail_loc = @tail.next
    tail_loc = @diskmap_size - tail_loc
    tail_blocks = [@tail_file_id] * tail_block_count

    while head_loc < tail_loc
      if head_loc.even?
        head_block_count.times do
          @new_diskmap << @head_file_id
          @checksum += @current_block_loc * @head_file_id
          @current_block_loc += 1
        end
        @head_file_id += 1
      else
        head_block_count.times do
          if tail_blocks.empty?
            begin
              tail_block_count, tail_loc = @tail.next
              tail_block_count, tail_loc = @tail.next
              tail_loc = @diskmap_size - tail_loc
              break if tail_loc <= head_loc
            rescue StopIteration
              break
            end

            @tail_file_id -= 1
            tail_blocks = [@tail_file_id] * tail_block_count
          end

          @new_diskmap << tail_blocks.pop
          @checksum += @current_block_loc * @tail_file_id
          @current_block_loc += 1
        end
      end

      begin
        head_block_count, head_loc = @head.next
      rescue StopIteration
        break
      end

      if head_loc == tail_loc - 1
        tail_blocks.each do |tail_block|
          @new_diskmap << tail_block
          @checksum += @current_block_loc * @tail_file_id
          @current_block_loc += 1
        end
        break
      end
    end
  end
end

compacter = DiskCompacter.new(diskmap)
compacter.compact!
puts compacter.checksum

puts "Part 2:"
class DiskCompacter2
  def initialize(diskmap)
    block_loc = -1
    @free_space = {}
    diskmap_index = 0
    @diskmap = {}
    diskmap.map.with_index do |block_count, index|
      next if block_count == 0

      if index.even?
        block_loc += 1
      else
        @free_space[diskmap_index] = block_count if block_count > 0
      end
      @diskmap[diskmap_index] = block_count.times.map { index.even? ? block_loc : "." }

      diskmap_index += block_count
    end
  end

  def compact!
    @diskmap.sort.reverse.each do |file_index, file_chunk|
      next if file_chunk.first == "."

      free_space_index, free_space_size = @free_space.filter do |index, free_space_size|
        free_space_size >= file_chunk.size && index < file_index
      end.sort.first
      next if free_space_index.nil?

      if free_space_size == file_chunk.size
        @diskmap[free_space_index] = file_chunk
        @diskmap[file_index] = ["."] * free_space_size

        @free_space.delete(free_space_index)
        @free_space[file_index] = free_space_size
      else
        @diskmap[free_space_index] = file_chunk
        remaining_free_space = free_space_size - file_chunk.size
        @diskmap[free_space_index + file_chunk.size] = ["."] * remaining_free_space
        @diskmap[file_index] = ["."] * file_chunk.size

        @free_space[free_space_index + file_chunk.size] = remaining_free_space
        @free_space.delete(free_space_index)
        @free_space[file_index] = file_chunk.size
      end
    end
  end


  def checksum
    @diskmap.sort.map(&:last).flatten.each_with_index.sum do |file_id, index|
      next 0 if file_id == "."
      file_id.to_i * index
    end
  end
end

compacter = DiskCompacter2.new(diskmap)
compacter.compact!
puts compacter.checksum
